
## Terraform Core version
*  0.12

## Providers
* aws ['>= 2.7.0']

## Inputs
| Name | Description | Type | Example | Default | Required |
|------|-------------|:----:|---------|:-------:|:--------:|
| aws_region | region to create the bucket | string |  | - | yes |
| backup_bucket_arn | arn of the backup bucket (when backup_replication = true) | nd |  | - | yes |
| backup_replication | Provide a description! | bool |  | False | no |
| backup_storage | storage class for the backup bucket | nd |  | - | yes |
| bucket_acl | bucket acl to apply to your bucket  | string |  private or public-read | private | no |
| bucket_role_backup | role of s3 bucket to be able to replicate to the backup bucket | nd |  | - | yes |
| cors_enable | enable cors on the s3 bucket | bool |  | False | no |
| cors_rule | cors rule to configure on s3 bucket (when enable_cors = true) | nd |  | {} | no |
| create | create resources for this module | bool |  | True | no |
| domain | add domain name to your bucket  | string |  .mydomain.com |  | no |
| environment | name of the environment associate to the s3 bucket  | string |  development, staging, production | - | yes |
| expiration_days | number of days to expire the current versions | number |  | - | yes |
| expiration_versioning_days | number of days to expire older versions than the current one | number |  | 7 | no |
| folders | folders to create inside s3 bucket | list(string) |  | [] | no |
| force_destroy | Provide a description! | bool |  | False | no |
| name | name of the bucket before appending other things | string |  | - | yes |
| namespace | name of the namespace associate to the s3 bucket  | string |  team1, main, poc | - | yes |
| rest_encryption | Provide a description! | bool |  | False | no |
| tags | tag to add to the s3 bucket | nd |  | {} | no |
| transitions | all the required transitions  | list(object({days = number, storage_type = string})) |  [{days = 30, storage_type = "GLACIER"}, {days = 60, storage_type = "GLACIER"}] | [] | no |
| versioning | enable versioning on the s3 bucket | bool |  | False | no |
| website | website properties for s3 bucket (when website_enable = true) | nd |  | {} | no |
| website_enable | enable website on s3 bucket | bool |  | False | no |

## Outputs
| Name | Description | Example |
|------|-------------|---------|
| s3_bucket | map with arn, name and id of the s3 bucket  |  s3_bucket["arn"] |
