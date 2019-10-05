
## Terraform Core version
*  0.12

## Providers
* aws ['>= 2.7.0']

## Inputs
| Name | Description | Type | Example | Default | Required |
|------|-------------|:----:|---------|:-------:|:--------:|
| actions_bucket_files | default s3 bucket actions associate with permissions (you should use defaults) | map(list(string)) |  | {'read': ['s3:ListBucket', 's3:GetObject'], 'readwrite': ['s3:ListBucket', 's3:PutObject', 's3:GetObject'], 'readwritedelete': ['s3:ListBucket', 's3:PutObject', 's3:GetObject', 's3:DeleteObject'], 'write': ['s3:ListBucket', 's3:PutObject']} | no |
| aws_region | aws region to be used | string |  | - | yes |
| backup_replication | create another bucket to keep asynchronous backups of your data | bool |  | False | no |
| backup_storage | standard, infrequent_access, archiver, deep_archiver | string |  | archiver | no |
| bucket_acl | acl to be applied to the bucket usually  | string |  private and public-read | private | no |
| cors_enable | enable cors on s3 bucket | bool |  | False | no |
| cors_rule | default cors rule defined for s3 bucket | object({max_age_seconds = number allowed_origins = list(string) allowed_methods = list(string) allowed_headers = list(string)}) |  |{'allowed_headers': ['*'], 'allowed_methods': ['GET', 'PUT'], 'allowed_origins': ['*'], 'max_age_seconds': 3000} | no |
| delete_protection | block everyone to delete the bucket or the content, need to be admins to manually delete it | bool |  | False | no |
| domain | domain if you need to add that to the name of your bucket  | string |  .mydomain.com |  | no |
| environment | environment to associate  | string |  dev, staging, production | - | yes |
| expiration_days | Number of days to keep objects stored in the bucket (0 to disable expiration) | nd |  | 0 | no |
| folders | list of all folders/directories you want to create inside your bucket | list(string) |  | [] | no |
| force_destroy | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error | bool |  | False | no |
| name | name for the s3 bucket without other things appended | string |  | - | yes |
| namespace | namespace to deploy  | string |  team1, main, poc | - | yes |
| other_allowed_arns | other allowed aws arns and their respective permission  | list(map(string)) |  [{arn = arn::xxx , permission = readwrite}, {arn = arn::yyy , permission = read}] | [] | no |
| permission | permissions for the s3 bucket [read, write, readwrite, readwritedelete] | string |  | read | no |
| rest_encryption | enable encryption at rest for your data | nd |  | False | no |
| role_arn | role id from your service (output from other module) | string |  | - | yes |
| service_name | name of your service  | string |  my-service-testing | - | yes |
| storage_types_mapping | translation of storage types to aws s3 (you should use defaults) | map(string) |  | {'archiver': 'GLACIER', 'deep_archiver': 'DEEP_ARCHIVE', 'infrequent_access': 'STANDARD_IA', 'standart': 'STANDARD'} | no |
| versioning | enable versioning on your bucket files | bool |  | False | no |
| website | website configuration on s3 bucket | object({index = string error = string}) |  | {'error': 'error.html', 'index': 'index.html'} | no |
| website_enable | enable website on s3 bucket | bool |  | False | no |

## Outputs
| Name | Description | Example |
|------|-------------|---------|
| s3_bucket | map with arn, name and id of the s3 bucket  |  s3_bucket["arn"] |
