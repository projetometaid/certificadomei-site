# ===== CERTIFICADO MEI - CONFIGURAÇÃO PRODUÇÃO =====

# Configurações básicas
aws_region   = "us-east-1"
environment  = "prod"
project_name = "certificadomei"

# Domínio customizado (deixe vazio para usar apenas CloudFront)
domain_name = "certificadodigitalmei.com.br"  # Seu domínio oficial

# Route 53 DNS (migração para melhor performance)
use_route53 = true  # Habilita DNS da AWS para performance superior

# CloudFront configurações
cloudfront_price_class = "PriceClass_100"  # US, Canada, Europa

# Monitoramento e segurança
enable_monitoring   = true
enable_waf         = false  # Pode gerar custos extras
enable_access_logs = true

# Backup e retenção
backup_retention_days = 30

# Tags
tags = {
  Owner       = "leandro.albertini@metaid.com.br"
  Project     = "certificadomei-site"
  Environment = "prod"
  ManagedBy   = "terraform"
  CostCenter  = "marketing"
  Department  = "ti"
}
