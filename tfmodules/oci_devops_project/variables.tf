# Devops Project details
variable "compartment_id" {}
variable "project_name" {
    default = "fsretools_cicd"
}
variable "project_description" {
  default = "OCI Devops project created by Terraform"
}
# code Repo
variable "repository_name" {
  default = "terraform_code_repo"
}
variable "repository_default_branch" {
  default = "refs/heads/main"
}
variable "repository_description" {
  default = "MicroService Code repository created by Terraform"
}
variable "repository_repository_type" {
  default = "HOSTED"
}
# Build pipeline
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

# Deploy pipeline
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

variable "oke_namespace" {
  default = "default"
}

variable "oci_cluster_id" {
  default = "ocid1.cluster.oc1.iad.aaaaaaaamfe5vkzbex5zkl2mnmud3w2f4coxhab4ldwqwd4mrc4y23snwevq"
}

variable "deploy_environment_description" {
  default = "OKE Cluster deploy environment"
}
variable "deploy_environment_display_name" {
  default = "storefrontDeploy"
}