# Devops Project details
variable "compartment_id" {}
variable "project_name" {
    default = "Java_micro_service"
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