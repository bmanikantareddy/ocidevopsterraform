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
            connection_type = var.build_pipeline_stage_build_source_collection_items_connection_type

            #Optional
            branch = var.build_pipeline_stage_build_source_collection_items_branch
            connection_id = oci_devops_connection.test_connection.id
            name = var.build_pipeline_stage_build_source_collection_items_name
            repository_id = oci_artifacts_repository.test_repository.id
            repository_url = var.build_pipeline_stage_build_source_collection_items_repository_url
        }
    }
    build_spec_file = var.build_pipeline_stage_build_spec_file
    defined_tags = {"foo-namespace.bar-key"= "value"}
    deliver_artifact_collection {

        #Optional
        items {

            #Optional
            artifact_id = oci_devops_artifact.test_artifact.id
            artifact_name = var.build_pipeline_stage_deliver_artifact_collection_items_artifact_name
        }
    }
    deploy_pipeline_id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    description = var.build_pipeline_stage_description
    display_name = var.build_pipeline_stage_display_name
    freeform_tags = {"bar-key"= "value"}
    image = var.build_pipeline_stage_image
    is_pass_all_parameters_enabled = var.build_pipeline_stage_is_pass_all_parameters_enabled
    primary_build_source = var.build_pipeline_stage_primary_build_source
    private_access_config {
        #Required
        network_channel_type = var.build_pipeline_stage_private_access_config_network_channel_type
        subnet_id = oci_core_subnet.test_subnet.id

        #Optional
        nsg_ids = var.build_pipeline_stage_private_access_config_nsg_ids
    }
    stage_execution_timeout_in_seconds = var.build_pipeline_stage_stage_execution_timeout_in_seconds
    wait_criteria {
        #Required
        wait_duration = var.build_pipeline_stage_wait_criteria_wait_duration
        wait_type = var.build_pipeline_stage_wait_criteria_wait_type
    }
}
