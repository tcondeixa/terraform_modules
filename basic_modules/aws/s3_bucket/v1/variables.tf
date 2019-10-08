variable "aws_region" {
  description = "region to create the bucket"
  type = string
}

variable "name" {
  description = "name of the bucket before appending other things"
  type = string
}

variable "domain" {
  description = "add domain name to your bucket example .mydomain.com"
  type = string
  default = ""
}

variable "bucket_acl" {
  description = "bucket acl to apply to your bucket example private or public-read"
  type = string
  default = "private"
}

variable "force_destroy" {
  type = bool
  default = false
}

variable "rest_encryption" {
  type = bool
  default = false
}

variable "backup_replication" {
  type = bool
  default = false
}

variable "backup_bucket_arn" {
  description = "arn of the backup bucket (when backup_replication = true)"
  default = null
}

variable "bucket_role_backup" {
  description = "role of s3 bucket to be able to replicate to the backup bucket"
  default = null
}

variable "versioning" {
  description = "enable versioning on the s3 bucket"
  type = bool
  default = false
}

variable "website_enable" {
  description = "enable website on s3 bucket"
  type = bool
  default = false
}

variable "website" {
  description = "website properties for s3 bucket (when website_enable = true)"
  default = {}
}

variable "cors_enable" {
  description = "enable cors on the s3 bucket"
  type = bool
  default = false
}

variable "cors_rule" {
  description = "cors rule to configure on s3 bucket (when enable_cors = true)"
  default = {}
}

variable "create" {
  description = "create resources for this module"
  type = bool
  default = true
}

variable "folders" {
  description = "folders to create inside s3 bucket"
  type    = list(string)
  default = []
}

variable "backup_storage" {
  description = "storage class for the backup bucket"
  default = null
}

variable "transitions" {
  description = "all the required transitions example [{days = 30, storage_type = \"GLACIER\"}, {days = 60, storage_type = \"GLACIER\"}]"
  type = list(object({days = number, storage_type = string}))
  default = []
}

variable "expiration_days" {
  description = "number of days to expire the current versions"
  type = number
  default = null
}

variable "expiration_versioning_days" {
  description = "number of days to expire older versions than the current one"
  type = number
  default = 7
}

variable "tags" {
  description = "tag to add to the s3 bucket"
  default = {}
}
