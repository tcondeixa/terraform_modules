output "s3_bucket" {
  description = "map with arn, name and id of the s3 bucket example s3_bucket[\"arn\"]"
  value = module.s3.s3_bucket
}
