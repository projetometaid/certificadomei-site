# ===== OUTPUTS - CERTIFICADO MEI INFRASTRUCTURE =====

# ===== S3 OUTPUTS =====
output "s3_bucket_name" {
  description = "Nome do bucket S3 criado"
  value       = aws_s3_bucket.website.bucket
}

output "s3_bucket_arn" {
  description = "ARN do bucket S3"
  value       = aws_s3_bucket.website.arn
}

output "s3_website_endpoint" {
  description = "Endpoint do website S3"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "s3_bucket_domain_name" {
  description = "Domain name do bucket S3"
  value       = aws_s3_bucket.website.bucket_domain_name
}

# ===== CLOUDFRONT OUTPUTS =====
output "cloudfront_distribution_id" {
  description = "ID da distribuição CloudFront"
  value       = aws_cloudfront_distribution.website.id
}

output "cloudfront_domain_name" {
  description = "Domain name da distribuição CloudFront"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "Hosted Zone ID da distribuição CloudFront"
  value       = aws_cloudfront_distribution.website.hosted_zone_id
}

output "cloudfront_arn" {
  description = "ARN da distribuição CloudFront"
  value       = aws_cloudfront_distribution.website.arn
}

# ===== SSL CERTIFICATE OUTPUTS =====
output "ssl_certificate_arn" {
  description = "ARN do certificado SSL (se domínio customizado)"
  value       = var.domain_name != "" ? aws_acm_certificate.website[0].arn : null
}

output "ssl_certificate_domain_validation_options" {
  description = "Opções de validação do certificado SSL"
  value       = var.domain_name != "" ? aws_acm_certificate.website[0].domain_validation_options : null
  sensitive   = true
}

# ===== WEBSITE URLS =====
output "website_url" {
  description = "URL principal do website"
  value       = var.domain_name != "" ? "https://${var.domain_name}" : "https://${aws_cloudfront_distribution.website.domain_name}"
}

output "website_url_cloudfront" {
  description = "URL do CloudFront (sempre disponível)"
  value       = "https://${aws_cloudfront_distribution.website.domain_name}"
}

output "website_url_s3" {
  description = "URL direta do S3 (para testes)"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}

# ===== DEPLOYMENT INFO =====
output "deployment_info" {
  description = "Informações importantes para deploy"
  value = {
    bucket_name           = aws_s3_bucket.website.bucket
    cloudfront_id         = aws_cloudfront_distribution.website.id
    website_url           = var.domain_name != "" ? "https://${var.domain_name}" : "https://${aws_cloudfront_distribution.website.domain_name}"
    environment           = var.environment
    region               = var.aws_region
    ssl_enabled          = var.domain_name != ""
    custom_domain        = var.domain_name
  }
}

# ===== AWS ACCOUNT INFO =====
output "aws_account_id" {
  description = "ID da conta AWS utilizada"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "Região AWS utilizada"
  value       = data.aws_region.current.name
}

# ===== COMMANDS FOR DEPLOYMENT =====
output "deployment_commands" {
  description = "Comandos para fazer deploy dos arquivos"
  value = {
    sync_files = "aws s3 sync . s3://${aws_s3_bucket.website.bucket} --exclude '*.git*' --exclude 'terraform/*' --exclude '*.md' --exclude 'comandos-github.sh'"
    invalidate_cache = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.website.id} --paths '/*'"
    website_url = var.domain_name != "" ? "https://${var.domain_name}" : "https://${aws_cloudfront_distribution.website.domain_name}"
  }
}

# ===== MONITORING OUTPUTS =====
output "monitoring_info" {
  description = "Informações para monitoramento"
  value = {
    cloudfront_distribution_id = aws_cloudfront_distribution.website.id
    s3_bucket_name            = aws_s3_bucket.website.bucket
    environment               = var.environment
    project_name              = var.project_name
  }
}

# ===== COST OPTIMIZATION =====
output "cost_optimization_tips" {
  description = "Dicas para otimização de custos"
  value = {
    cloudfront_price_class = var.cloudfront_price_class
    s3_storage_class      = "STANDARD"
    monitoring_enabled    = var.enable_monitoring
    estimated_monthly_cost = "~$1-5 USD (dependendo do tráfego)"
  }
}
