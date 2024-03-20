



resource "oci_devops_project" "devops_project" {
    #Required
    compartment_id = var.compartment_id
    name = var.project_name
    notification_config {
        #Required
        topic_id = oci_ons_notification_topic.devops_notification_topic.id
    }
    #Optional
    defined_tags = {"foo-namespace.bar-key"= "value"}
    description = var.project_description
    depends_on = [oci_ons_notification_topic.devops_notification_topic]
}

output "project_id" {
  value = oci_devops_project.devops_project.id
}