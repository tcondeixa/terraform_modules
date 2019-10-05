variable "aws_region" {
  description = "aws region to be used"
  type = string
}

variable "environment" {
  description = "environment to associate example dev, staging, production"
  type = string
}

variable "namespace" {
  description = "namespace to deploy example team1, main, poc"
  type = string
}

variable "service_name" {
  description = "name of your service example my-service-testing"
  type = string
}

variable "name" {
  description = "name for the s3 bucket without other things appended"
  type = string
}

variable "domain" {
  description = "domain if you need to add that to the name of your bucket example .mydomain.com"
  type        = string
  default     = ""
}

variable "folders" {
  description = "list of all folders/directories you want to create inside your bucket"
  type        = list(string)
  default     = []
}

variable "role_arn" {
  description = "role id from your service (output from other module)"
  type = string
  default = null
}

variable "bucket_acl" {
  description = "acl to be applied to the bucket usually example private and public-read"
  type = string
  default = "private"
}

variable "versioning" {
  description = "enable versioning on your bucket files"
  type        = bool
  default     = false
}

variable "rest_encryption" {
  description = "enable encryption at rest for your data"
  default     = false
}

variable "delete_protection" {
  description = "block everyone to delete the bucket or the content, need to be admins to manually delete it"
  type        = bool
  default     = false
}

variable "backup_replication" {
  description = "create another bucket to keep asynchronous backups of your data"
  type        = bool
  default     = false
}

variable "backup_storage" {
  description = "standard, infrequent_access, archiver, deep_archiver"
  type = string
  default = "archiver"
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type = bool
  default = false
}

variable "permission" {
  description = "permissions for the s3 bucket [read, write, readwrite, readwritedelete]"
  type        = string
  default     = "read"
}

variable "other_allowed_arns" {
  description = "other allowed aws arns and their respective permission example [{arn = arn::xxx , permission = readwrite}, {arn = arn::yyy , permission = read}]"
  type        = list(map(string))
  default     = []
}

variable "website_enable" {
  description = "enable website on s3 bucket"
  type = bool
  default = false
}

variable "website" {
  description = "website configuration on s3 bucket"
  type = object({
    index = string
    error = string
  })
  default = {
    index = "index.html"
    error = "error.html"
  }
}

variable "cors_enable" {
  description = "enable cors on s3 bucket"
  type = bool
  default = false
}

variable "cors_rule" {
  description = "default cors rule defined for s3 bucket"
  type = object({
    max_age_seconds = number
    allowed_origins = list(string)
    allowed_methods = list(string)
    allowed_headers = list(string)
  })
  default = {
    max_age_seconds = 3000
    allowed_origins = [
      "*"]
    allowed_methods = [
      "GET",
      "PUT"]
    allowed_headers = [
      "*"]
  }
}

variable "actions_bucket_files" {
  description = "default s3 bucket actions associate with permissions (you should use defaults)"
  type        = map(list(string))
  default = {
    read  = ["s3:ListBucket","s3:GetObject"]
    write = ["s3:ListBucket","s3:PutObject"]
    readwrite = ["s3:ListBucket","s3:PutObject","s3:GetObject"]
    readwritedelete = ["s3:ListBucket","s3:PutObject","s3:GetObject","s3:DeleteObject"]
  }
}

variable "storage_types_mapping" {
  description = "translation of storage types to aws s3 (you should use defaults)"
  type        = map(string)
  default = {
    standart  = "STANDARD"
    infrequent_access  = "STANDARD_IA"
    archiver = "GLACIER"
    deep_archiver = "DEEP_ARCHIVE"
  }
}

variable "expiration_days" {
  description = "Number of days to keep objects stored in the bucket (0 to disable expiration)"
  default     = 0
}
