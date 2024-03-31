# outputs.tf

# Define your output values here
output "topic_id" {
  value = oci_ons_notification_topic.devops_notification_topic.id
}
output "kms_signing_key" {
    value = oci_kms_key.sign_mek.id
}
output "kms_signing_key_version" {
    value = oci_kms_key.sign_mek.current_key_version
}
output "auth_token" {
    value = oci_identity_auth_token.auth_token.token
}

output "ocirtoken_vault_ocid" {
  value = oci_vault_secret.ocirtoken.id
}

output "knowledge_base_id" {
  value = oci_adm_knowledge_base.knowledge_base.id
}