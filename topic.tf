
# variable "notification_topic_description" {
#   default = "Topic for OCI Devops Porject"
# }

# variable "notification_topic_name" {
#   default = "ocidevops_topic"
# }

# resource "oci_ons_notification_topic" "devops_notification_topic" {
#     compartment_id = var.compartment_id
#     name = var.notification_topic_name
#     description = var.notification_topic_description
# }

# output "topic_id" {
#   value = oci_ons_notification_topic.devops_notification_topic.id
# }