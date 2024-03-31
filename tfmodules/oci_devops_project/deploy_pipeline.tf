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

resource "oci_devops_deploy_environment" "deploy_environment" {
    #Required
    deploy_environment_type = "OKE_CLUSTER"
    project_id = oci_devops_project.devops_project.id

    #Optional
    cluster_id = var.oci_cluster_id
    description = var.deploy_environment_description
    display_name = var.deploy_environment_display_name
}

resource "oci_devops_deploy_stage" "deploy_stage" {
    #Required
    deploy_pipeline_id = oci_devops_deploy_pipeline.deploy_pipeline.id
    deploy_stage_predecessor_collection {
        #Required
        items {
            #Required
            id = oci_devops_deploy_pipeline.deploy_pipeline.id
        }
    }
    deploy_stage_type = "OKE_DEPLOYMENT"
    description = "Deploy kubernetes manifest files"
    display_name = "storefrontDeploy"
    namespace = var.oke_namespace
    kubernetes_manifest_deploy_artifact_ids = [
      oci_devops_deploy_artifact.deploy_artifact_serviceyaml.id,
      oci_devops_deploy_artifact.deploy_artifact_deploymentyaml.id
    ]
    oke_cluster_deploy_environment_id = oci_devops_deploy_environment.deploy_environment.id
}
