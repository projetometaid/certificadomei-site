# 🔧 GUIA TÉCNICO - MANUTENÇÃO DO PROJETO

## 📋 **INFORMAÇÕES ESSENCIAIS**

### **Estrutura do Projeto**:
```
certificadodigitalmei/
├── index.html              # Página principal
├── compra.html             # Página de compra (original)
├── compra                  # Página de compra (URL canônica)
├── style.css               # CSS principal (ÚNICO em uso)
├── sitemap.xml             # Mapa do site
├── robots.txt              # Diretrizes para crawlers
├── assets/
│   ├── favicons/           # Todos os favicons
│   ├── images/             # Imagens do site
│   ├── js/                 # JavaScript
│   └── logos/              # Logotipos
└── terraform/              # Infraestrutura AWS
```

### **URLs Importantes**:
- **Site Principal**: https://www.certificadodigitalmei.com.br
- **Página de Compra**: https://www.certificadodigitalmei.com.br/compra
- **CloudFront**: https://d2xkp5x4bz18ec.cloudfront.net

---

## 🚀 **COMANDOS DE DEPLOY**

### **Deploy Completo**:
```bash
cd /Applications/deploy/certificadodigitalmei
./terraform/deploy.sh deploy-only
```

### **Deploy Manual (S3 + CloudFront)**:
```bash
# 1. Sincronizar arquivos
aws s3 sync . s3://certificadomei-prod-xqdxohz7 \
    --exclude "*.git*" \
    --exclude "terraform/*" \
    --exclude "*.md" \
    --exclude "comandos-github.sh" \
    --exclude "*.DS_Store" \
    --delete

# 2. Invalidar cache
aws cloudfront create-invalidation \
    --distribution-id E1GQUUOUF4PKI9 \
    --paths "/*"
```

### **Deploy de Arquivo Específico**:
```bash
# Exemplo: atualizar apenas index.html
aws s3 cp index.html s3://certificadomei-prod-xqdxohz7/index.html
aws cloudfront create-invalidation --distribution-id E1GQUUOUF4PKI9 --paths "/index.html"
```

---

## 📝 **PADRÕES DE DESENVOLVIMENTO**

### **Alterações no FAQ**:
1. Editar seção em `index.html` (linhas ~357-445)
2. Manter estrutura HTML existente
3. Usar IDs sequenciais: `faq-1`, `faq-2`, etc.
4. Sempre fazer deploy após alterações

### **Novos Links Internos**:
- ✅ **USAR**: `href="/compra"` (URL canônica)
- ❌ **NÃO USAR**: `href="/compra.html"`
- ❌ **NÃO USAR**: `rel="nofollow"` em links internos

### **Favicons**:
- **Ordem de prioridade**: 192x192 → 32x32 → 16x16 → favicon.ico
- **Localização**: `/assets/favicons/`
- **Não alterar** a ordem otimizada atual

---

## 🔍 **COMANDOS DE VALIDAÇÃO**

### **Testar URLs**:
```bash
# Verificar página principal
curl -I https://www.certificadodigitalmei.com.br/

# Verificar página de compra
curl -I https://www.certificadodigitalmei.com.br/compra

# Testar com Googlebot
curl -A "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" \
     -I https://www.certificadodigitalmei.com.br/compra

# Verificar meta robots
curl -s https://www.certificadodigitalmei.com.br/compra | grep -i "robots"

# Verificar canonical
curl -s https://www.certificadodigitalmei.com.br/compra | grep -i "canonical"
```

### **Verificar Status da Infraestrutura**:
```bash
# Status da distribuição CloudFront
aws cloudfront get-distribution --id E1GQUUOUF4PKI9

# Listar invalidações em andamento
aws cloudfront list-invalidations --distribution-id E1GQUUOUF4PKI9

# Verificar bucket S3
aws s3 ls s3://certificadomei-prod-xqdxohz7/
```

---

## 🛠️ **RESOLUÇÃO DE PROBLEMAS COMUNS**

### **Problema: Página não atualiza**
```bash
# Solução: Invalidar cache específico
aws cloudfront create-invalidation \
    --distribution-id E1GQUUOUF4PKI9 \
    --paths "/index.html" "/compra"
```

### **Problema: CSS não carrega**
```bash
# Verificar se style.css existe
aws s3 ls s3://certificadomei-prod-xqdxohz7/style.css

# Re-upload com content-type correto
aws s3 cp style.css s3://certificadomei-prod-xqdxohz7/style.css \
    --content-type "text/css"
```

### **Problema: Favicon não aparece**
```bash
# Verificar todos os favicons
aws s3 ls s3://certificadomei-prod-xqdxohz7/assets/favicons/

# Invalidar cache dos favicons
aws cloudfront create-invalidation \
    --distribution-id E1GQUUOUF4PKI9 \
    --paths "/assets/favicons/*"
```

---

## 📊 **MONITORAMENTO E SEO**

### **Google Search Console**:
- **URL**: https://search.google.com/search-console
- **Propriedade**: certificadodigitalmei.com.br
- **Monitorar**: Páginas indexadas, Core Web Vitals, erros de crawl

### **Métricas Importantes**:
- **Indexação**: `/compra` deve estar indexada (não mais em "noindex")
- **Core Web Vitals**: LCP < 2.5s, FID < 100ms, CLS < 0.1
- **Performance**: PageSpeed Insights > 90

### **Sitemap**:
- **URL**: https://www.certificadodigitalmei.com.br/sitemap.xml
- **Última atualização**: 17/01/2025
- **Páginas**: 6 URLs principais

---

## 🔐 **CREDENCIAIS E ACESSOS**

### **AWS**:
- **Conta**: 099670158004
- **Região**: us-east-1
- **Usuário**: projetometaid
- **Email**: leandro.albertini@metaid.com.br

### **GitHub**:
- **Repositório**: projetometaid/certificadomei-site
- **Branch principal**: main
- **Último commit**: 3cb0f2a

### **Domínio**:
- **Registrar**: (verificar com cliente)
- **DNS**: Route 53 (AWS)
- **SSL**: ACM (AWS) - Renovação automática

---

## ⚠️ **CUIDADOS IMPORTANTES**

### **NÃO FAZER**:
- ❌ Alterar estrutura do Terraform sem backup
- ❌ Deletar arquivos do bucket S3 sem confirmação
- ❌ Modificar configurações do CloudFront diretamente
- ❌ Usar `rel="nofollow"` em links internos
- ❌ Voltar URLs para `/compra.html`

### **SEMPRE FAZER**:
- ✅ Testar alterações localmente primeiro
- ✅ Fazer backup antes de mudanças grandes
- ✅ Commitar alterações no Git
- ✅ Validar URLs após deploy
- ✅ Monitorar Google Search Console

---

## 📞 **CONTATOS DE EMERGÊNCIA**

- **Desenvolvedor**: Leandro Albertini
- **Email**: leandro.albertini@metaid.com.br
- **Empresa**: MetaID
- **Projeto**: Certificado Digital MEI

---

**📅 Criado em**: 20/08/2025
**🔄 Versão**: 1.0
**✅ Status**: Documentação completa e atualizada
