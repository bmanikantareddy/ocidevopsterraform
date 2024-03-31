# Need to work on it to store the statefile in OCI bucket.
# terraform {
#   backend "s3" {
#     bucket         = "ocidevops-terraform-state"
#     key            = "terraform.tfstate"
#     region         = "us-ashburn-1"
#     endpoints {
#       s3 = "https://objectstorage.us-ashburn-1.oraclecloud.com"
#     }
#     skip_region_validation = true
#     skip_credentials_validation = true
#   }
# }

terraform {
  backend "http" {
    update_method = "PUT"
    address       = "https://objectstorage.us-ashburn-1.oraclecloud.com/p/vykH0EbRlb-78ZQSmi8GdUZt7rxex0jBmWXUNPeuTno15OBQB5mWEXp1OTvUNtGP/n/idlmjvvqgjze/b/fsretools_terraform_state_files/o/fsretools_devops_project_tfstatefile/terraform.state"

# https://objectstorage.us-ashburn-1.oraclecloud.com/p/vykH0EbRlb-78ZQSmi8GdUZt7rxex0jBmWXUNPeuTno15OBQB5mWEXp1OTvUNtGP/n/idlmjvvqgjze/b/fsretools_terraform_state_files/o/
  }
}


# terraform {
#   backend "s3" {
#     bucket                      = "ocidevops-terraform-state"
#     key                         = "terraform.tfstate"
#     region                      = "us-ashburn-1"
#     endpoints = "https://idj2eg1x3f00.compat.objectstorage.us-ashburn-1.oraclecloud.com"
#     skip_region_validation      = true
#     skip_credentials_validation = true
#     skip_requesting_account_id  = true
#     skip_metadata_api_check     = true
#     force_path_style            = true
#   }
# }

# customer secret key : HBQFIJulL7NC5EO672IyIx+hresxC8eMH5MG5BbnzQs=


# terraform {
#   backend "s3" {
#     bucket = "ocidevops-terraform-state"
#     region = "us-ashburn-1"
#     key = "terraform.tfstate"
#     skip_region_validation = true
#     skip_credentials_validation = true
#     skip_requesting_account_id = true
#     use_path_style = true
#     #insecure = true
#     skip_metadata_api_check = true
#     access_key = "nikhilperla46@gmail.com"
#     secret_key = "HBQFIJulL7NC5EO672IyIx+hresxC8eMH5MG5BbnzQs="
#     endpoints = { s3 = "https://idj2eg1x3f00.compat.objectstorage.us-ashburn-1.oraclecloud.com" } 
#   }
# }