variable "build_pipeline_name" {
  default = "MicroServiceBuildPipeLine"
}
variable "build_pipeline_description" {
  default = "Build Pipeline to compile,package & build docker/helm packages"
}
# variable "build_pipeline_description" {
#   default = ""
# }
resource "oci_devops_build_pipeline" "build_pipeline" {
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

resource "oci_devops_build_pipeline_stage" "compile_build_pipeline_stage" {
    #Required
    build_pipeline_id = oci_devops_build_pipeline.build_pipeline.id
    build_pipeline_stage_predecessor_collection {
        #Required
        items {
            #Required
            id = oci_devops_build_pipeline.build_pipeline.id
        }
    }
    build_pipeline_stage_type = "BUILD"

    build_source_collection {

        #Optional
        items {
            #Required
            connection_type = "DEVOPS_CODE_REPOSITORY"

            #Optional
            branch = "main"
            name = oci_devops_repository.code_repository.name
            repository_id = oci_devops_repository.code_repository.id
            repository_url = oci_devops_repository.code_repository.http_url
        }
    }
    primary_build_source = oci_devops_repository.code_repository.name
    build_spec_file = "helidon-storefront-full/yaml/build/build_spec.yaml"
    description = "compile ,package ,build docker and push to artifact repo"
    display_name = "build_docker"
    image = "OL7_X86_64_STANDARD_10"

    stage_execution_timeout_in_seconds = 36000
}
