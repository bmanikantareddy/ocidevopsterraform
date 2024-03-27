variable "knowledge_base_display_name" {
  default = "KB_FSRE_TOOLS"
}
resource "oci_adm_knowledge_base" "knowledge_base" {
    compartment_id = var.compartment_id
    display_name = var.knowledge_base_display_name
}