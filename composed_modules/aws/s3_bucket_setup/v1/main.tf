module "s3" {
  source = "../../../../basic_modules/aws/s3_bucket/v1"

  create              = true
  aws_region          = var.aws_region
  environment         = var.environment
  namespace           = var.namespace
  name                = "${var.environment}-${var.namespace}-${var.name}-${var.aws_region}${var.domain}"
  folders             = var.folders

  bucket_acl          = var.bucket_acl
  versioning          = var.versioning
  force_destroy       = var.force_destroy
  rest_encryption     = var.rest_encryption
  expiration_days     = var.expiration_days

  website_enable      = var.website_enable
  website             = var.website
  cors_enable         = var.cors_enable
  cors_rule           = var.cors_rule

  backup_replication  = var.backup_replication
  backup_bucket_arn   = var.backup_replication ? module.s3_backup.s3_bucket["arn"] : null
  backup_storage      = var.backup_replication ? var.storage_types_mapping[var.backup_storage] : null
  bucket_role_backup  = var.backup_replication ? aws_iam_role.s3_replication[0].arn : null

  tags = {
    Region=var.aws_region,
    Environment=var.environment,
    Namespace=var.namespace,
    Name="${var.environment}-${var.namespace}-${var.name}-${var.aws_region}${var.domain}"
  }
}

locals {
  role = var.role_arn != null ? [{arn = var.role_arn, permission = var.permission}] : []
  delete = var.delete_protection ? [{actions = ["s3:Delete*"], identifiers = ["*"]}] : []
}

data "aws_iam_policy_document" "s3_iam_policy" {
  count = length(local.role) + length(var.other_allowed_arns) + length(local.delete) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = concat(local.role, var.other_allowed_arns)
    content {
      actions   = var.actions_bucket_files[statement.value.permission]
      effect = "Allow"
      resources = [module.s3.s3_bucket["arn"], "${module.s3.s3_bucket["arn"]}/*"]

      principals {
        type        = "AWS"
        identifiers = [statement.value.arn]
      }
    }
  }

  dynamic "statement" {
    for_each = local.delete
    content {
      actions   = statement.value.actions
      effect    = "Deny"
      resources = ["${module.s3.s3_bucket["arn"]}/*",module.s3.s3_bucket["arn"]]

      principals {
        type        = "AWS"
        identifiers = statement.value.identifiers
      }
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count = length(local.role) + length(var.other_allowed_arns) + length(local.delete) > 0 ? 1 : 0

  bucket = module.s3.s3_bucket["id"]
  policy = data.aws_iam_policy_document.s3_iam_policy.0.json
}



### Cross-Replication ###
module "s3_backup" {
  source = "../../../../basic_modules/aws/s3_bucket/v1"

  create          = var.backup_replication
  aws_region      = var.aws_region
  environment     = var.environment
  namespace       = var.namespace
  name            = "${var.environment}-${var.namespace}-${var.name}-backup-${var.aws_region}${var.domain}"

  bucket_acl          = var.bucket_acl
  versioning          = var.versioning
  force_destroy       = var.force_destroy
  rest_encryption     = var.rest_encryption
}

data "aws_iam_policy_document" "s3_iam_replication_policy" {
  count = var.backup_replication ? 1 : 0

  statement {
    actions   = ["s3:ListBucket","s3:Get*"]
    effect    = "Allow"
    resources = ["${module.s3.s3_bucket["arn"]}/*", module.s3.s3_bucket["arn"]]
  }

  statement {
    actions   = ["s3:ReplicateObject","s3:ReplicateDelete","s3:ReplicateTags","s3:GetObjectVersionTagging"]
    effect    = "Allow"
    resources = ["${module.s3_backup.s3_bucket["arn"]}/*"]
  }
}

resource "aws_iam_policy" "s3_iam_replication_policy" {
  count = var.backup_replication ? 1 : 0

  name   = "${var.environment}-${var.namespace}-${var.name}-${var.aws_region}-s3_iam_replication_policy"
  policy = data.aws_iam_policy_document.s3_iam_replication_policy[0].json
}

resource "aws_iam_role" "s3_replication" {
  count = var.backup_replication ? 1 : 0

  name               = "${var.environment}-${var.namespace}-${var.name}-${var.aws_region}-replication"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "s3_iam_replication_policy" {
  count = var.backup_replication ? 1 : 0

  policy_arn = aws_iam_policy.s3_iam_replication_policy[0].arn
  role       = aws_iam_role.s3_replication[0].name
}
