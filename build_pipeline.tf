variable "build_pipeline_name" {
  default = "MicroServiceBuildPipeLine"
}
variable "build_pipeline_description" {
  default = "Build Pipeline to compile,package & build docker/helm packages"
}
# variable "build_pipeline_description" {
#   default = ""
# }
resource "oci_devops_build_pipeline" "test_build_pipeline" {
  project_id = oci_devops_project.devops_project.id

  description  = var.build_pipeline_description
  display_name = var.build_pipeline_name
  
  build_pipeline_parameters {
        items {
            name = "USER_AUTH_TOKEN"
            default_value = "sampleuser_AuthTOken"
            description = "User auth token to push helm packages."
        }
    }
}