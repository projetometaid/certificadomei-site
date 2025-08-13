#!/bin/bash

# ===== DEPLOY SCRIPT - CERTIFICADO MEI =====
# Script para deploy automatizado da infraestrutura e website
# Author: Leandro Albertini

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_requirements() {
    log_info "Verificando dependências..."
    
    if ! command -v terraform &> /dev/null; then
        log_error "Terraform não está instalado. Instale: https://terraform.io/downloads"
        exit 1
    fi
    
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI não está instalado. Instale: https://aws.amazon.com/cli/"
        exit 1
    fi
    
    # Check AWS credentials
    if ! aws sts get-caller-identity &> /dev/null; then
        log_error "AWS credentials não configuradas. Execute: aws configure"
        exit 1
    fi
    
    log_success "Todas as dependências estão instaladas"
}

# Initialize Terraform
init_terraform() {
    log_info "Inicializando Terraform..."
    
    cd terraform
    
    if [ ! -f "terraform.tfvars" ]; then
        log_warning "terraform.tfvars não encontrado. Copiando exemplo..."
        cp terraform.tfvars.example terraform.tfvars
        log_warning "IMPORTANTE: Edite terraform.tfvars com suas configurações antes de continuar"
        read -p "Pressione Enter após editar terraform.tfvars..."
    fi
    
    terraform init
    log_success "Terraform inicializado"
}

# Plan infrastructure
plan_infrastructure() {
    log_info "Planejando infraestrutura..."
    terraform plan -out=tfplan
    log_success "Plano criado. Revise as mudanças acima."
}

# Apply infrastructure
apply_infrastructure() {
    log_info "Aplicando infraestrutura..."
    terraform apply tfplan
    log_success "Infraestrutura criada com sucesso!"
}

# Deploy website files
deploy_website() {
    log_info "Fazendo deploy dos arquivos do website..."
    
    # Get bucket name from Terraform output
    BUCKET_NAME=$(terraform output -raw s3_bucket_name)
    CLOUDFRONT_ID=$(terraform output -raw cloudfront_distribution_id)
    
    if [ -z "$BUCKET_NAME" ]; then
        log_error "Não foi possível obter o nome do bucket. Verifique se a infraestrutura foi criada."
        exit 1
    fi
    
    log_info "Bucket: $BUCKET_NAME"
    log_info "CloudFront ID: $CLOUDFRONT_ID"
    
    # Go back to project root
    cd ..
    
    # Sync files to S3
    log_info "Sincronizando arquivos com S3..."
    aws s3 sync . s3://$BUCKET_NAME \
        --exclude "*.git*" \
        --exclude "terraform/*" \
        --exclude "*.md" \
        --exclude "comandos-github.sh" \
        --exclude "*.DS_Store" \
        --delete
    
    # Set proper content types
    log_info "Configurando content-types..."
    aws s3 cp s3://$BUCKET_NAME/style.css s3://$BUCKET_NAME/style.css --content-type "text/css" --metadata-directive REPLACE
    aws s3 cp s3://$BUCKET_NAME/assets/js/main.js s3://$BUCKET_NAME/assets/js/main.js --content-type "application/javascript" --metadata-directive REPLACE
    
    # Invalidate CloudFront cache
    log_info "Invalidando cache do CloudFront..."
    aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_ID --paths "/*"
    
    log_success "Deploy do website concluído!"
}

# Show deployment info
show_info() {
    cd terraform
    
    log_info "=== INFORMAÇÕES DO DEPLOY ==="
    terraform output deployment_info
    
    echo ""
    log_info "=== URLs DO WEBSITE ==="
    terraform output website_url
    terraform output website_url_cloudfront
    
    echo ""
    log_info "=== COMANDOS ÚTEIS ==="
    echo "Bucket S3: $(terraform output -raw s3_bucket_name)"
    echo "CloudFront ID: $(terraform output -raw cloudfront_distribution_id)"
    echo ""
    echo "Para fazer deploy manual:"
    echo "aws s3 sync . s3://$(terraform output -raw s3_bucket_name) --exclude '*.git*' --exclude 'terraform/*'"
    echo "aws cloudfront create-invalidation --distribution-id $(terraform output -raw cloudfront_distribution_id) --paths '/*'"
}

# Main execution
main() {
    log_info "=== DEPLOY CERTIFICADO MEI - AWS INFRASTRUCTURE ==="
    
    case "${1:-all}" in
        "check")
            check_requirements
            ;;
        "init")
            check_requirements
            init_terraform
            ;;
        "plan")
            check_requirements
            init_terraform
            plan_infrastructure
            ;;
        "apply")
            check_requirements
            init_terraform
            plan_infrastructure
            
            echo ""
            log_warning "Você está prestes a criar recursos na AWS que podem gerar custos."
            read -p "Deseja continuar? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                apply_infrastructure
                deploy_website
                show_info
            else
                log_info "Deploy cancelado."
            fi
            ;;
        "deploy-only")
            deploy_website
            ;;
        "info")
            show_info
            ;;
        "destroy")
            log_warning "ATENÇÃO: Isso irá DESTRUIR toda a infraestrutura!"
            read -p "Tem certeza? Digite 'yes' para confirmar: " confirm
            if [ "$confirm" = "yes" ]; then
                cd terraform
                terraform destroy
                log_success "Infraestrutura destruída."
            else
                log_info "Destruição cancelada."
            fi
            ;;
        "all"|*)
            check_requirements
            init_terraform
            plan_infrastructure
            
            echo ""
            log_warning "Você está prestes a criar recursos na AWS que podem gerar custos."
            read -p "Deseja continuar? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                apply_infrastructure
                deploy_website
                show_info
            else
                log_info "Deploy cancelado."
            fi
            ;;
    esac
}

# Show usage if help requested
if [[ "${1}" == "--help" || "${1}" == "-h" ]]; then
    echo "Uso: $0 [comando]"
    echo ""
    echo "Comandos disponíveis:"
    echo "  all        - Deploy completo (padrão)"
    echo "  check      - Verificar dependências"
    echo "  init       - Inicializar Terraform"
    echo "  plan       - Planejar mudanças"
    echo "  apply      - Aplicar infraestrutura e deploy"
    echo "  deploy-only - Apenas deploy dos arquivos"
    echo "  info       - Mostrar informações do deploy"
    echo "  destroy    - Destruir infraestrutura"
    echo "  --help     - Mostrar esta ajuda"
    exit 0
fi

# Execute main function
main "$1"
