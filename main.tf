module "prereq" {
  source = "./tfmodules/pre_requisites"  # Path to your module directory or module registry URL
  // Pass variables to the module
  tenancy_ocid = var.tenancy_ocid
  compartment_id = var.compartment_id
  user_ocid = var.user_ocid

}

module "pipeline" {
  source = "./tfmodules/oci_devops_project"  # Path to your module directory or module registry URL
  
  // Pass variables to the module
#   tenancy_ocid = var.tenancy_ocid
  compartment_id = var.compartment_id
#   user_ocid = var.user_ocid
}