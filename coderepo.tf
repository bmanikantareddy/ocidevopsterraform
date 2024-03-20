variable "repository_name" {
  default = "terraform_code_repo"
}
variable "repository_default_branch" {
  default = "main"
}
variable "repository_description" {
  default = "MicroService Code repository created by Terraform"
}
variable "repository_repository_type" {
  default = "HOSTED"
}

resource "oci_devops_repository" "test_repository" {
  #Required
  name       = var.repository_name
  project_id = oci_devops_project.test_project.id

  #Optional
  default_branch = var.repository_default_branch
  description    = var.repository_description

  repository_type = var.repository_repository_type

}