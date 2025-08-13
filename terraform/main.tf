# ===== CERTIFICADO MEI - INFRAESTRUTURA AWS =====
# Terraform configuration for static website hosting
# Author: Leandro Albertini
# Project: certificadomei-site

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # Backend para state remoto (descomente quando configurar)
  # backend "s3" {
  #   bucket = "certificadomei-terraform-state"
  #   key    = "terraform.tfstate"
  #   region = "us-east-1"
  # }
}

# ===== PROVIDER CONFIGURATION =====
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "certificadomei-site"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "leandro.albertini@metaid.com.br"
    }
  }
}

# Provider para us-east-1 (necessário para CloudFront certificates)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  
  default_tags {
    tags = {
      Project     = "certificadomei-site"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "leandro.albertini@metaid.com.br"
    }
  }
}

# ===== DATA SOURCES =====
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ===== LOCALS =====
locals {
  bucket_name = "${var.project_name}-${var.environment}-${random_string.bucket_suffix.result}"
  domain_name = var.domain_name != "" ? var.domain_name : "${local.bucket_name}.s3-website-${var.aws_region}.amazonaws.com"
  
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "leandro.albertini@metaid.com.br"
  }
}

# Random string para bucket name único
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# ===== S3 BUCKET PARA WEBSITE =====
resource "aws_s3_bucket" "website" {
  bucket = local.bucket_name
  
  tags = merge(local.common_tags, {
    Name = "Website Bucket"
    Type = "Static Website"
  })
}

# S3 Bucket versioning
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket public access block
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket website configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# S3 Bucket policy para acesso público
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  depends_on = [aws_s3_bucket_public_access_block.website]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# ===== CLOUDFRONT DISTRIBUTION =====
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "${var.project_name}-${var.environment}-oac"
  description                       = "OAC for ${var.project_name} website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
    origin_id                = "S3-${aws_s3_bucket.website.bucket}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project_name} website distribution"
  default_root_object = "index.html"

  # Aliases (custom domains)
  aliases = var.domain_name != "" ? [var.domain_name, "www.${var.domain_name}"] : []

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.website.bucket}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  # Cache behavior para assets estáticos
  ordered_cache_behavior {
    path_pattern     = "/assets/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-${aws_s3_bucket.website.bucket}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 31536000  # 1 ano
    max_ttl                = 31536000  # 1 ano
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = var.cloudfront_price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL Certificate
  viewer_certificate {
    cloudfront_default_certificate = var.domain_name == "" ? true : false
    acm_certificate_arn            = var.domain_name != "" ? (var.use_route53 ? aws_acm_certificate_validation.website[0].certificate_arn : aws_acm_certificate.website[0].arn) : null
    ssl_support_method             = var.domain_name != "" ? "sni-only" : null
    minimum_protocol_version       = var.domain_name != "" ? "TLSv1.2_2021" : null
  }

  # Custom error responses
  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/error.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 404
    response_page_path = "/error.html"
  }

  tags = merge(local.common_tags, {
    Name = "Website CloudFront"
    Type = "CDN"
  })
}

# ===== ROUTE 53 HOSTED ZONE (se domínio customizado) =====
resource "aws_route53_zone" "website" {
  count = var.domain_name != "" && var.use_route53 ? 1 : 0

  name = var.domain_name

  tags = merge(local.common_tags, {
    Name = "Website DNS Zone"
    Type = "DNS"
  })
}

# ===== SSL CERTIFICATE (se domínio customizado) =====
resource "aws_acm_certificate" "website" {
  count = var.domain_name != "" ? 1 : 0

  provider          = aws.us_east_1
  domain_name       = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.common_tags, {
    Name = "Website SSL Certificate"
    Type = "SSL"
  })
}

# ===== SSL CERTIFICATE VALIDATION =====
resource "aws_route53_record" "website_certificate_validation" {
  for_each = var.domain_name != "" && var.use_route53 ? {
    for dvo in aws_acm_certificate.website[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.website[0].zone_id
}

resource "aws_acm_certificate_validation" "website" {
  count = var.domain_name != "" && var.use_route53 ? 1 : 0

  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.website[0].arn
  validation_record_fqdns = [for record in aws_route53_record.website_certificate_validation : record.fqdn]
}

# ===== DNS RECORDS PARA O WEBSITE =====
resource "aws_route53_record" "website" {
  count = var.domain_name != "" && var.use_route53 ? 1 : 0

  zone_id = aws_route53_zone.website[0].zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_www" {
  count = var.domain_name != "" && var.use_route53 ? 1 : 0

  zone_id = aws_route53_zone.website[0].zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}
