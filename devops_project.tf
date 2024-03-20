resource "oci_devops_project" "devops_project" {
    compartment_id = var.compartment_id
    name = var.project_name
    notification_config {
        topic_id = oci_ons_notification_topic.devops_notification_topic.id
    }
    description = var.project_description
    depends_on = [oci_ons_notification_topic.devops_notification_topic]
}


resource "oci_logging_configuration" "example_logging_config" {
  compartment_id = var.compartment_id
  name           = "example-logging-config"
  description    = "Example logging configuration"

  log_sources {
    service     = "devops"
    resource_id = oci_devops_project.devops_project.id
  }
}

output "project_id" {
  value = oci_devops_project.devops_project.id
}