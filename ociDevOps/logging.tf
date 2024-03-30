# The above code didn't enabling the Created devops project logs.
resource "oci_logging_log_group" "default_group" {
  compartment_id = var.compartment_id
  display_name = "oci_devops_group" # Log Group name
  description = "Terraform oci devops logging group"
}

resource "oci_logging_log" "devops_log" {
  display_name = var.project_name
  #compartment_id = var.compartment_id
  log_group_id   = oci_logging_log_group.default_group.id
  is_enabled = true
  retention_duration = 30

  # Log details
  log_type       = "SERVICE"
   configuration {
        #Required
        source {
            #Required
            category = "all"
            resource = oci_devops_project.devops_project.id
            service = "devops"
            source_type = "OCISERVICE"
        }
    }
}
