module "prereq" {
  source = "./tfmodules/pre_requisites"  # Path to your module directory or module registry URL
  // Pass variables to the module
  tenancy_ocid = var.tenancy_ocid
  compartment_id = var.compartment_id
  user_ocid = var.user_ocid
}

locals {
  combined_parameters = concat(
    var.build_pipeline_parameters,
    [
      {
        default_value = module.prereq.kms_signing_key_version
        description   = "Signing key version OCID"
        name          = "SIGNING_KEY_VERSION"
      },
      {
        default_value = module.prereq.kms_signing_key
        description   = "OCIR Signing Key OCID"
        name          = "SIGNING_KEY_OCIR"
      },
      {
        default_value = module.prereq.ocirtoken_vault_ocid
        description   = "docker token to push images. OCID of secret created in Vault."
        name          = "VAULT_DOCKER_TOKEN"
      },

      {
        default_value = module.prereq.knowledge_base_id
        description   = "Knowledge base OCID VulnerabilityAudit of repo code"
        name          = "KB_OCID"
      },
      # Add more additional parameters as needed
    ]
  )
}

module "pipeline" {
  source = "./tfmodules/oci_devops_project"  # Path to your module directory or module registry URL
  
  // Pass variables to the module
#   tenancy_ocid = var.tenancy_ocid
  compartment_id = var.compartment_id
  topic_id = module.prereq.topic_id
  project_name = var.project_name
  project_description = var.project_description
  build_pipeline_parameters = local.combined_parameters
  build_pipeline_name = var.build_pipeline_name
  build_pipeline_description = var.build_pipeline_description
  repository_name = var.repository_name
}