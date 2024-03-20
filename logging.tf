resource "oci_logging_log_group" "devops_log_group" {
  compartment_id = var.compartment_id
  display_name   = "devops_project_logs"
  description    = "Log group for OCI DevOps project"
  depends_on = [oci_devops_project.devops_project]
}

resource "oci_logging_log" "test_log" {
    #Required
    display_name = "devops_project_log"
    log_group_id = oci_logging_log_group.devops_log_group.id
    log_type = "SERVICE"

    #Optional
    configuration {
        #Required
        source {
            #Required
            category    = "oci_devops_project"
            service     = "devops"
            source_type = "OCISERVICE"
           
            resource = oci_logging_log_group.devops_log_group.id
        }

        #Optional
        compartment_id = var.compartment_id
    }
    is_enabled = true
    retention_duration = 30
    depends_on = [oci_logging_log_group.devops_log_group]
}