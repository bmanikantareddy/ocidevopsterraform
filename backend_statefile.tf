# Need to work on it to store the statefile in OCI bucket.
# terraform {
#   backend "s3" {
#     bucket         = "your-bucket-name"
#     key            = "terraform.tfstate"
#     region         = "your-region"
#     endpoint       = "https://objectstorage.region.oraclecloud.com"
#     skip_region_validation = true
#     skip_credentials_validation = true
#     skip_get_ec2_platforms = true
#     skip_metadata_api_check = true
#     skip_requesting_account_id = true
#     skip_credentials_validation = true
#     skip_region_validation = true
#     skip_metadata_api_check = true
#     force_path_style = true
#     shared_credentials_file = "/path/to/oci_credentials" // Optional, if not set, default location is used
#     profile = "default" // Optional, if not set, uses default profile in shared_credentials_file
#   }
# }
