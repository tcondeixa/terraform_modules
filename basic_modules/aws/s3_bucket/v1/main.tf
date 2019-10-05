locals {
  encryption_alg = var.rest_encryption ? [{sse_algorithm: "AES256"}] : []
  replication = var.backup_replication ? [{status: "Enabled"}] : []
  expiration_days = var.expiration_days != 0 ? [{days: var.expiration_days}] : []
  noncurrent_version_expiration = var.expiration_versioning_days != 0 ? [{days: var.expiration_versioning_days}] : []
  cors_rule = var.cors_enable ? [var.cors_rule] : []
  website = var.website_enable ? [var.website] : []
}

resource "aws_s3_bucket" "bucket" {
  count         = var.create ? 1 : 0

  bucket        = var.name
  acl           = var.bucket_acl
  region        = var.aws_region
  force_destroy = var.force_destroy

  versioning {
    enabled = var.versioning
  }

  dynamic "cors_rule" {
    for_each = local.cors_rule
    content {
      allowed_origins = cors_rule.value.allowed_origins
      allowed_methods = cors_rule.value.allowed_methods
      max_age_seconds = cors_rule.value.max_age_seconds
      allowed_headers = cors_rule.value.allowed_headers
    }
  }


  dynamic "website" {
    for_each = local.website
    content {
      index_document = website.value.index
      error_document = website.value.error
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = local.encryption_alg
    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = server_side_encryption_configuration.value.sse_algorithm
        }
      }
    }
  }

  dynamic "replication_configuration" {
    for_each = local.replication
    content {
      role = var.bucket_role_backup
      rules {
        id = "${var.name}-rule"
        priority = 0
        prefix = ""
        status = replication_configuration.value.status
        destination {
          bucket = var.backup_bucket_arn
          storage_class = var.backup_storage
        }
      }
    }
  }

  lifecycle_rule {
    enabled = length(var.transitions) + length(local.expiration_days) + length(local.noncurrent_version_expiration) > 0 ? true : false

    dynamic "transition" {
      for_each = var.transitions
      content {
        days = transition.value.days
        storage_class = transition.value.storage_class
      }
    }

    dynamic "expiration" {
      for_each = local.expiration_days
      content {
        days = expiration.value.days
      }
    }

    dynamic "noncurrent_version_expiration" {
      for_each = local.noncurrent_version_expiration
      content {
        days = noncurrent_version_expiration.value.days
      }
    }
  }

  tags = var.tags

}

resource "aws_s3_bucket_object" "bucket" {
  count = var.create ? length(var.folders) : 0

  bucket = aws_s3_bucket.bucket[0].id
  acl    = var.bucket_acl
  key    = var.folders[count.index]
  source = "/dev/null"
}
