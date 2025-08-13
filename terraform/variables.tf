# ===== VARIABLES - CERTIFICADO MEI INFRASTRUCTURE =====

variable "aws_region" {
  description = "AWS region para deploy da infraestrutura"
  type        = string
  default     = "us-east-1"
  
  validation {
    condition = contains([
      "us-east-1", "us-west-2", "eu-west-1", 
      "ap-southeast-1", "sa-east-1"
    ], var.aws_region)
    error_message = "Região deve ser uma das regiões suportadas."
  }
}

variable "environment" {
  description = "Ambiente de deploy (dev, staging, prod)"
  type        = string
  default     = "prod"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment deve ser dev, staging ou prod."
  }
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "certificadomei"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "domain_name" {
  description = "Domínio customizado para o site (opcional). Ex: certificadodigitalmei.com.br"
  type        = string
  default     = ""

  validation {
    condition = var.domain_name == "" || can(regex("^[a-z0-9.-]+\\.[a-z]{2,}$", var.domain_name))
    error_message = "Domain name deve ser um domínio válido ou string vazia."
  }
}

variable "use_route53" {
  description = "Usar Route 53 para gerenciar DNS automaticamente"
  type        = bool
  default     = false
}

variable "cloudfront_price_class" {
  description = "Classe de preço do CloudFront"
  type        = string
  default     = "PriceClass_100"  # Apenas US, Canada e Europa
  
  validation {
    condition = contains([
      "PriceClass_All",     # Todas as edge locations
      "PriceClass_200",     # US, Canada, Europa, Asia, Middle East, Africa
      "PriceClass_100"      # US, Canada, Europa
    ], var.cloudfront_price_class)
    error_message = "Price class deve ser PriceClass_All, PriceClass_200 ou PriceClass_100."
  }
}

variable "enable_monitoring" {
  description = "Habilitar monitoramento CloudWatch"
  type        = bool
  default     = true
}

variable "enable_waf" {
  description = "Habilitar AWS WAF para proteção"
  type        = bool
  default     = false  # Pode gerar custos adicionais
}

variable "backup_retention_days" {
  description = "Dias de retenção para backups do S3"
  type        = number
  default     = 30
  
  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 365
    error_message = "Retention days deve estar entre 1 e 365."
  }
}

variable "enable_access_logs" {
  description = "Habilitar logs de acesso do CloudFront"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais para recursos"
  type        = map(string)
  default = {
    Owner       = "leandro.albertini@metaid.com.br"
    Project     = "certificadomei-site"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

# ===== COMPUTED VARIABLES =====
locals {
  # Configurações baseadas no ambiente
  environment_config = {
    dev = {
      instance_count = 1
      monitoring     = false
      backup_days    = 7
    }
    staging = {
      instance_count = 1
      monitoring     = true
      backup_days    = 14
    }
    prod = {
      instance_count = 2
      monitoring     = true
      backup_days    = 30
    }
  }
  
  current_config = local.environment_config[var.environment]
}
