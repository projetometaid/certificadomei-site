# 🚀 Certificado MEI - Infraestrutura AWS

Infraestrutura como código (IaC) usando Terraform para hospedar o site do Certificado Digital MEI na AWS.

## 🏗️ Arquitetura

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   CloudFront    │────│   S3 Bucket      │────│   Website       │
│   (CDN Global)  │    │   (Static Host)  │    │   (HTML/CSS/JS) │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                        │
         │                        │
┌─────────────────┐    ┌──────────────────┐
│   Route 53      │    │   ACM SSL        │
│   (DNS)         │    │   (Certificate)  │
└─────────────────┘    └──────────────────┘
```

### Componentes:
- **S3 Bucket** - Hospedagem de site estático
- **CloudFront** - CDN global com cache otimizado
- **ACM Certificate** - SSL/TLS gratuito (se domínio customizado)
- **Route 53** - DNS (opcional)
- **CloudWatch** - Monitoramento

## 📋 Pré-requisitos

### 1. Ferramentas Necessárias
```bash
# Terraform (>= 1.0)
brew install terraform  # macOS
# ou baixe de: https://terraform.io/downloads

# AWS CLI (>= 2.0)
brew install awscli     # macOS
# ou baixe de: https://aws.amazon.com/cli/

# Git
brew install git        # macOS
```

### 2. Configurar AWS CLI
```bash
aws configure
# AWS Access Key ID: [sua-access-key]
# AWS Secret Access Key: [sua-secret-key]
# Default region name: us-east-1
# Default output format: json
```

### 3. Verificar Credenciais
```bash
aws sts get-caller-identity
```

## 🚀 Deploy Rápido

### Opção 1: Deploy Automatizado (Recomendado)
```bash
# Tornar script executável
chmod +x terraform/deploy.sh

# Deploy completo
./terraform/deploy.sh

# Ou por etapas
./terraform/deploy.sh check    # Verificar dependências
./terraform/deploy.sh plan     # Planejar mudanças
./terraform/deploy.sh apply    # Aplicar e fazer deploy
```

### Opção 2: Deploy Manual
```bash
# 1. Configurar variáveis
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com suas configurações

# 2. Inicializar Terraform
terraform init

# 3. Planejar mudanças
terraform plan

# 4. Aplicar infraestrutura
terraform apply

# 5. Deploy dos arquivos
cd ..
aws s3 sync . s3://$(cd terraform && terraform output -raw s3_bucket_name) \
    --exclude "*.git*" --exclude "terraform/*" --exclude "*.md"

# 6. Invalidar cache CloudFront
aws cloudfront create-invalidation \
    --distribution-id $(cd terraform && terraform output -raw cloudfront_distribution_id) \
    --paths "/*"
```

## ⚙️ Configuração

### terraform.tfvars
```hcl
# Configurações básicas
aws_region   = "us-east-1"
environment  = "prod"
project_name = "certificadomei"

# Domínio customizado (opcional)
domain_name = "certificadodigitalmei.com.br"  # ou "" para usar CloudFront

# CloudFront
cloudfront_price_class = "PriceClass_100"  # US/CA/EU apenas

# Monitoramento
enable_monitoring = true
enable_waf       = false  # Gera custos extras
```

### Ambientes
- **dev**: Desenvolvimento, sem monitoramento
- **staging**: Homologação, monitoramento básico
- **prod**: Produção, monitoramento completo

## 🌐 Domínio Customizado

### Com Domínio Próprio
1. Configure `domain_name` no terraform.tfvars
2. Após deploy, configure DNS:
   ```
   certificadodigitalmei.com.br    CNAME  d123456789.cloudfront.net
   www.certificadodigitalmei.com.br CNAME  d123456789.cloudfront.net
   ```

### Sem Domínio (CloudFront apenas)
1. Deixe `domain_name = ""`
2. Use URL do CloudFront: `https://d123456789.cloudfront.net`

## 📊 Monitoramento

### CloudWatch Metrics
- Requests, Data Transfer, Error Rate
- Cache Hit Ratio, Origin Latency

### Logs
- CloudFront Access Logs (se habilitado)
- S3 Server Access Logs

### Alertas (Opcional)
```bash
# Criar alertas CloudWatch
aws cloudwatch put-metric-alarm \
    --alarm-name "certificadomei-high-error-rate" \
    --alarm-description "High 4xx/5xx error rate" \
    --metric-name 4xxErrorRate \
    --namespace AWS/CloudFront \
    --statistic Average \
    --period 300 \
    --threshold 5.0 \
    --comparison-operator GreaterThanThreshold
```

## 💰 Custos Estimados

### Produção (tráfego médio)
- **S3**: ~$1-3/mês (storage + requests)
- **CloudFront**: ~$1-10/mês (data transfer)
- **Route 53**: ~$0.50/mês (hosted zone)
- **ACM**: Gratuito
- **Total**: ~$2-15/mês

### Otimizações de Custo
- Use `PriceClass_100` para CloudFront
- Configure lifecycle policies no S3
- Monitore usage com AWS Cost Explorer

## 🔧 Comandos Úteis

### Terraform
```bash
# Ver outputs
terraform output

# Ver estado
terraform show

# Importar recurso existente
terraform import aws_s3_bucket.website bucket-name

# Refresh state
terraform refresh
```

### AWS CLI
```bash
# Listar buckets
aws s3 ls

# Sync arquivos
aws s3 sync . s3://bucket-name --delete

# Invalidar cache
aws cloudfront create-invalidation --distribution-id ID --paths "/*"

# Ver distribuições CloudFront
aws cloudfront list-distributions
```

### Deploy
```bash
# Deploy apenas arquivos (sem infraestrutura)
./deploy.sh deploy-only

# Ver informações do deploy
./deploy.sh info

# Destruir tudo
./deploy.sh destroy
```

## 🛠️ Troubleshooting

### Problemas Comuns

#### 1. Erro de Credenciais AWS
```bash
# Verificar credenciais
aws sts get-caller-identity

# Reconfigurar
aws configure
```

#### 2. Bucket já existe
```bash
# Importar bucket existente
terraform import aws_s3_bucket.website bucket-name
```

#### 3. Certificado SSL não valida
- Verifique registros DNS
- Aguarde até 30 minutos para propagação

#### 4. CloudFront não atualiza
```bash
# Invalidar cache manualmente
aws cloudfront create-invalidation --distribution-id ID --paths "/*"
```

### Logs de Debug
```bash
# Terraform debug
export TF_LOG=DEBUG
terraform apply

# AWS CLI debug
aws s3 ls --debug
```

## 🔒 Segurança

### Boas Práticas
- Use IAM roles com permissões mínimas
- Habilite MFA na conta AWS
- Configure AWS Config para compliance
- Use AWS WAF se necessário (custos extras)

### Backup
- S3 Versioning habilitado
- Cross-region replication (opcional)
- Lifecycle policies para otimizar custos

## 📚 Recursos Adicionais

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS S3 Static Website](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [AWS CLI Reference](https://docs.aws.amazon.com/cli/latest/reference/)

## 📞 Suporte

Para dúvidas ou problemas:
- **Email**: leandro.albertini@metaid.com.br
- **Projeto**: certificadomei-site
- **Repositório**: https://github.com/projetometaid/certificadomei-site
