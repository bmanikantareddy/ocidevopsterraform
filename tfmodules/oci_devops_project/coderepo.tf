resource "oci_devops_repository" "code_repository" {
  #Required
  name       = var.repository_name
  project_id = oci_devops_project.devops_project.id

  #Optional
  default_branch = var.repository_default_branch
  description    = var.repository_description

  repository_type = var.repository_repository_type

}

output "code_repo" {
  value = {
    http_url = oci_devops_repository.code_repository.http_url
    ssh_url  = oci_devops_repository.code_repository.ssh_url
  }
}

#TODO 
# NULL Resource and add code and git push 