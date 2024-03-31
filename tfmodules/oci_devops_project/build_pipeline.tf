# variables for buildpipeline
resource "oci_devops_build_pipeline" "build_pipeline" {
  project_id     = oci_devops_project.devops_project.id
  description    = var.build_pipeline_description
  display_name   = var.build_pipeline_name

  build_pipeline_parameters {
    dynamic "items" {
      for_each = var.build_pipeline_parameters #local.combined_parameters

      content {
        name           = items.value.name
        default_value  = items.value.default_value
        description    = items.value.description
      }
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

resource "oci_devops_build_pipeline_stage" "collect_artifacts" {
    #Required
    build_pipeline_id = oci_devops_build_pipeline.build_pipeline.id
    build_pipeline_stage_predecessor_collection {
        #Required
        items {
            #Required
            id = oci_devops_build_pipeline_stage.compile_build_pipeline_stage.id
        }
    }
    build_pipeline_stage_type = "DELIVER_ARTIFACT"
    description = "saveArtifcats from previous stage and push items to artifact repo"
    display_name = "saveArtifacts"
    stage_execution_timeout_in_seconds = 36000

    deliver_artifact_collection {
    items {
      artifact_id   = oci_devops_deploy_artifact.deploy_artifact_serviceyaml.id
      artifact_name = "service_yaml"
    }
    items {
      artifact_id   = oci_devops_deploy_artifact.deploy_artifact_deploymentyaml.id
      artifact_name = "deployment_yaml"
    }
  }
}

resource "oci_devops_build_pipeline_stage" "trigger_deployment" {
    #Required
    build_pipeline_id = oci_devops_build_pipeline.build_pipeline.id
    build_pipeline_stage_predecessor_collection {
        #Required
        items {
            #Required
            id = oci_devops_build_pipeline_stage.collect_artifacts.id
        }
    }
    # need to replace this after creating deploy pipeline tf resource
    deploy_pipeline_id = oci_devops_deploy_pipeline.deploy_pipeline.id
    build_pipeline_stage_type = "TRIGGER_DEPLOYMENT_PIPELINE"
    description = "Build Pipeline To trigger deployment pipeline"
    display_name = "TriggerStoreFrontDeploymentPipeline"
    stage_execution_timeout_in_seconds = 36000
    is_pass_all_parameters_enabled = true
}

resource "oci_devops_deploy_artifact" "deploy_artifact_serviceyaml" {
    #Required
    argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
    deploy_artifact_source {
        #Required
        deploy_artifact_source_type = "GENERIC_ARTIFACT"

        deploy_artifact_path = "storefrontserviceyaml"
        deploy_artifact_version = "$${STOREFRONT_VERSION}"

        repository_id = "ocid1.artifactrepository.oc1.iad.0.amaaaaaadtxgs2aabqzqzdzqu7a5lsropiba7mvsqjculsadvhluvsyytwpq"
    }
    deploy_artifact_type = "KUBERNETES_MANIFEST"
    project_id = oci_devops_project.devops_project.id

    description = "kuberentes manifest for service yaml storefront app"
    display_name = "storefrontserviceyaml"
}

resource "oci_devops_deploy_artifact" "deploy_artifact_deploymentyaml" {
    #Required
    argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
    deploy_artifact_source {
        #Required
        deploy_artifact_source_type = "GENERIC_ARTIFACT"

        deploy_artifact_path = "storefrontdeploymentyaml"
        deploy_artifact_version = "$${STOREFRONT_VERSION}"

        repository_id = "ocid1.artifactrepository.oc1.iad.0.amaaaaaadtxgs2aabqzqzdzqu7a5lsropiba7mvsqjculsadvhluvsyytwpq"
    }
    deploy_artifact_type = "KUBERNETES_MANIFEST"
    project_id = oci_devops_project.devops_project.id

    description = "kuberentes manifest for deployment yaml storefront app"
    display_name = "storefrontdeploymentyaml"
}