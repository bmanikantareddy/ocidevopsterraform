### vars for provider OCI

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "oci_username" {}
variable "oci_user_authtoken" {}
variable "config_file_profile" { 
    default = "DEFAULT"
}

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      #version = "~> 4.44.0"  # Use the appropriate version
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region       = var.region

  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  config_file_profile = "DEFAULT"
}
