output "s3_bucket" {
  description = "map with arn, name and id of the s3 bucket example s3_bucket[\"arn\"]"
  value = map (
    "arn", var.create ? aws_s3_bucket.bucket[0].arn : null,
    "name", var.create ? aws_s3_bucket.bucket[0].bucket : null,
    "id", var.create ? aws_s3_bucket.bucket[0].id : null
  )
}
