# Devops Project details
variable "compartment_id" {}
variable "project_name" {}
variable "project_description" {}
variable "topic_id" {}
# code Repo
variable "repository_name" {}
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
variable "build_pipeline_name" {}
variable "build_pipeline_description" {
  default = "Build Pipeline to compile,package & build docker/helm packages"
}

variable "build_pipeline_parameters" {
  type = list(object({
    default_value = string
    description   = string
    name          = string
  }))
  default = []
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