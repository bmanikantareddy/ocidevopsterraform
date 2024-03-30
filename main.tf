module "prereq" {
  source = "./preRequisites "  # Path to your module directory or module registry URL
  
  // Pass variables to the module
  compartment_id = var.compartment_id
}

module "pipeline" {
  source = "./ociDevOps"  # Path to your module directory or module registry URL
  
  // Pass variables to the module
  compartment_id = var.compartment_id
}