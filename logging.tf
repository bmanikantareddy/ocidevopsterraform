# resource "oci_logging_log_group" "devops_log_group" {
#   compartment_id = var.compartment_id
#   display_name   = "devops_project_logs"
#   description    = "Log group for OCI DevOps project"
#   depends_on = [oci_devops_project.devops_project]
# }

# resource "oci_logging_log" "devops_log" {
#     #Required
#     display_name = "devops_project_logs_all"
#     log_group_id = oci_logging_log_group.devops_log_group.id
#     log_type = "SERVICE"

#     #Optional
#     configuration {
#         #Required
#         source {
#             #Required
#             category    = "all"
#             service     = "DevOps"
#             source_type = "OCISERVICE"
           
#             resource = oci_logging_log_group.devops_log_group.id
#         }

#         #Optional
#         compartment_id = var.compartment_id
#     }
#     is_enabled = true
#     retention_duration = 30
#     depends_on = [oci_logging_log_group.devops_log_group]
# }


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
