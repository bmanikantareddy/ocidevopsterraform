variable "deploy_pipeline_parameters" {
  type = list(object({
    default_value = string
    description   = string
    name          = string
  }))
  default = [
    {
      name           = "STOREFRONT_VERSION"
      default_value  = "abc123"
      description    = "StoreFront Verison from Build Pipeline"
    },
    {
      name           = "IMAGE_DIGEST"
      default_value  = "sha256value"
      description    = "Image digest sha256 value from Build PipeLine"
    },
  ]
}

variable "deploy_pipeline_description" {
    default = "Deployment pipeline to deploy Kubernetes Manifest files to cluster"
}
variable "deploy_pipeline_display_name" {
    default = "StoreFrontDeployPipeline"
}

resource "oci_devops_deploy_pipeline" "deploy_pipeline" {
    #Required
    project_id = oci_devops_project.devops_project.id

    deploy_pipeline_parameters {
        dynamic "items" {
        for_each = var.deploy_pipeline_parameters

        content {
            name           = items.value.name
            default_value  = items.value.default_value
            description    = items.value.description
        }
        }
    }

    description = var.deploy_pipeline_description
    display_name = var.deploy_pipeline_display_name
}