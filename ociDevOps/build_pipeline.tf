# variables for buildpipeline
variable "build_pipeline_name" {
  default = "MicroServiceBuildPipeLine"
}
variable "build_pipeline_description" {
  default = "Build Pipeline to compile,package & build docker/helm packages"
}

variable "build_pipeline_parameters" {
  type = list(object({
    default_value = string
    description   = string
    name          = string
  }))
  default = [
    {
      default_value = "oal_devops_project/storefront"
      description   = "repo name to be used as a docker image name"
      name          = "REPO_NAME_PROD"
    },
    {
      default_value = "oal_devops_project_dev/storefront"
      description   = "repo name to be used as a docker image name"
      name          = "REPO_NAME_DEV"
    },
    {
      default_value = "ocid1.vaultsecret.oc1.iad.amaaaaaadtxgs2aa7mjztyucsuizlnmrbllgwxryocdwiohxfys4ma6i2sgq"
      description   = "sonar token to push analysis to sonar server. secret OCID created in vault"
      name          = "VAULT_SONAR_TOKEN"
    },
    {
      default_value = "ocid1.vaultsecret.oc1.iad.amaaaaaadtxgs2aar55eppjfglazqs2hyouc4i5xw4nbylpgbkruethgmczq"
      description   = "sonar url stored in vault. secret ocid"
      name          = "VAULT_SONAR_URL"
    },
    {
      default_value = "ocid1.vaultsecret.oc1.iad.amaaaaaadtxgs2aaeqkejiphdno4zhkbwckh7a3ip5ox525dv32k5mfkcm2a"
      description   = "userMail ID stored in vault. secret OCID "
      name          = "VAULT_USER_EMAIL"
    },
    {
      default_value = "ocid1.vaultsecret.oc1.iad.amaaaaaadtxgs2aa2mtwjiryeu3sgij3gmwe2motztt5whk4lgnhwfr6d5qq"
      description   = "OCIR storage namespace from secret vault created secret OCID."
      name          = "VAULT_STORAGE_NAMESPACE"
    },
    {
      default_value = "ocid1.vaultsecret.oc1.iad.amaaaaaadtxgs2aa6emgxzcmewtpwwikw4tckwtr7y33mzrc2iorga6xc5za"
      description   = "OCIR host OCID. secret OCID created in vault"
      name          = "VAULT_HOST_OCID"
    },

    {
      default_value = "OAL_STORE_FRONT_POC"
      description   = "Team's project Name"
      name          = "PROJECT_NAME"
    },
    {
      default_value = "ocid1.compartment.oc1..aaaaaaaaxcuuupi5or6vcu242qdm4iit4vwigbwke2kdjksfzrbksbrq6tia"
      description   = "build pipeline managed comartment OCID"
      name          = "COMPARTMENT_OCID"
    },
    {
      default_value = "no"
      description   = "supported values yes,no. default: no"
      name          = "production"
    },
  ]
}

locals {
  combined_parameters = concat(
    var.build_pipeline_parameters,
    [
      {
        default_value = oci_kms_key.sign_mek.current_key_version
        description   = "Signing key version OCID"
        name          = "SIGNING_KEY_VERSION"
      },
      {
        default_value = oci_kms_key.sign_mek.id
        description   = "OCIR Signing Key OCID"
        name          = "SIGNING_KEY_OCIR"
      },

      {
        default_value = oci_identity_auth_token.auth_token.token
        description   = "docker token to push images. OCID of secret created in Vault."
        name          = "VAULT_DOCKER_TOKEN"
      },

      {
        default_value = oci_adm_knowledge_base.knowledge_base.id
        description   = "Knowledge base OCID VulnerabilityAudit of repo code"
        name          = "KB_OCID"
      },
      # Add more additional parameters as needed
    ]
  )
}


resource "oci_devops_build_pipeline" "build_pipeline" {
  project_id     = oci_devops_project.devops_project.id
  description    = var.build_pipeline_description
  display_name   = var.build_pipeline_name

  build_pipeline_parameters {
    dynamic "items" {
      for_each = local.combined_parameters #var.build_pipeline_parameters

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