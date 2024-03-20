variable "notification_topic_description" {
  default = "Topic for OCI Devops Porject"
}

variable "notification_topic_name" {
  default = "ocidevops_topic"
}
variable "project_name" {
    default = "Java_micro_service"
}

variable "project_description" {
  default = "OCI Devops project created by Terraform"
}

variable "compartment_id" {
  default = "ocid1.compartment.oc1..aaaaaaaaxcuuupi5or6vcu242qdm4iit4vwigbwke2kdjksfzrbksbrq6tia"
}


### for provider OCI

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