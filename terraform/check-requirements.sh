#!/bin/bash

# ===== CHECK REQUIREMENTS - CERTIFICADO MEI =====
# Script para verificar se todos os pré-requisitos estão instalados

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "🔍 Verificando pré-requisitos para deploy do Certificado MEI..."
echo ""

# Check Terraform
if command -v terraform &> /dev/null; then
    TERRAFORM_VERSION=$(terraform version | head -n1 | cut -d' ' -f2)
    log_success "Terraform instalado: $TERRAFORM_VERSION"
else
    log_error "Terraform não encontrado"
    echo "   Instale: https://terraform.io/downloads"
    echo "   macOS: brew install terraform"
    exit 1
fi

# Check AWS CLI
if command -v aws &> /dev/null; then
    AWS_VERSION=$(aws --version | cut -d' ' -f1)
    log_success "AWS CLI instalado: $AWS_VERSION"
else
    log_error "AWS CLI não encontrado"
    echo "   Instale: https://aws.amazon.com/cli/"
    echo "   macOS: brew install awscli"
    exit 1
fi

# Check AWS credentials
if aws sts get-caller-identity &> /dev/null; then
    AWS_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
    AWS_USER=$(aws sts get-caller-identity --query Arn --output text | cut -d'/' -f2)
    log_success "AWS credentials configuradas"
    log_info "   Conta: $AWS_ACCOUNT"
    log_info "   Usuário: $AWS_USER"
else
    log_error "AWS credentials não configuradas"
    echo "   Execute: aws configure"
    echo "   Você precisará de:"
    echo "   - AWS Access Key ID"
    echo "   - AWS Secret Access Key"
    echo "   - Default region (recomendado: us-east-1)"
    exit 1
fi

# Check AWS permissions
log_info "Verificando permissões AWS..."

# Test S3 permissions
if aws s3 ls &> /dev/null; then
    log_success "Permissões S3: OK"
else
    log_warning "Permissões S3: Limitadas ou inexistentes"
fi

# Test CloudFront permissions
if aws cloudfront list-distributions &> /dev/null; then
    log_success "Permissões CloudFront: OK"
else
    log_warning "Permissões CloudFront: Limitadas ou inexistentes"
fi

# Check if terraform.tfvars exists
if [ -f "terraform.tfvars" ]; then
    log_success "terraform.tfvars encontrado"
else
    log_warning "terraform.tfvars não encontrado"
    echo "   Será criado automaticamente durante o deploy"
fi

# Check Git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    log_success "Git instalado: $GIT_VERSION"
else
    log_warning "Git não encontrado (opcional)"
fi

# Estimate costs
echo ""
log_info "💰 Estimativa de custos mensais:"
echo "   S3 Storage (1GB): ~$0.02"
echo "   S3 Requests: ~$0.01"
echo "   CloudFront (1GB transfer): ~$0.08"
echo "   Route 53 (se usar domínio): ~$0.50"
echo "   Total estimado: $0.10 - $5.00/mês"
echo ""

# Show next steps
log_info "📋 Próximos passos:"
echo "1. Configure terraform.tfvars (se necessário)"
echo "2. Execute: ./deploy.sh"
echo "3. Aguarde a criação da infraestrutura"
echo "4. Acesse o site via URL fornecida"
echo ""

log_success "✅ Todos os pré-requisitos estão atendidos!"
echo "Você está pronto para fazer o deploy! 🚀"
