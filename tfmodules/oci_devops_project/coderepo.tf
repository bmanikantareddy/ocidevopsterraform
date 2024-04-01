resource "oci_devops_repository" "code_repository" {
  #Required
  name       = var.repository_name
  project_id = oci_devops_project.devops_project.id

  #Optional
  default_branch = var.repository_default_branch
  description    = var.repository_description

  repository_type = var.repository_repository_type

}

resource "oci_devops_trigger" "devops_trigger" {
    #Required
    actions {
        #Required
        build_pipeline_id = oci_devops_build_pipeline.build_pipeline.id
        type = "TRIGGER_BUILD_PIPELINE"

        #Optional
        filter {
            #Required
            trigger_source = "DEVOPS_CODE_REPOSITORY"

            #Optional
            events = [ "PUSH", ]
            include {

                #Optional
                base_ref = ""
                head_ref = "main"
                repository_name = oci_devops_repository.code_repository.name
            }
        }
    }
    project_id = oci_devops_project.devops_project.id
    trigger_source = "DEVOPS_CODE_REPOSITORY"

    description = "Trigger Build Pipeline on code push"
    display_name = "trigger_${oci_devops_repository.code_repository.name}"
    repository_id = oci_devops_repository.code_repository.id
}


output "code_repo" {
  value = {
    http_url = oci_devops_repository.code_repository.http_url
    ssh_url  = oci_devops_repository.code_repository.ssh_url
  }
}

#TODO 
# NULL Resource and add code and git push 