# main.tf

################# TOPIC ###################
# Topic for OCI Devops
resource "oci_ons_notification_topic" "devops_notification_topic" {
    compartment_id = var.compartment_id
    name = var.notification_topic_name
    description = var.notification_topic_description
}

############### VAULT #######################
# OCI Vault to be used in OCI devops project
resource "oci_kms_vault" "devops_vault" {
    count           = var.use_existing_vault ? 0 : 1
    compartment_id = var.compartment_id
    display_name   = var.vault_name
    vault_type = var.vault_type
}

data "oci_kms_vault" "devops_vault_existing" {
    count = var.use_existing_vault ? 1 : 0
    vault_id = var.existing_vault_id
}

locals {
  selected_vault = var.use_existing_vault ? data.oci_kms_vault.devops_vault_existing[0] : oci_kms_vault.devops_vault[0]
}

resource "oci_kms_key" "default_mek" {
  compartment_id        = local.selected_vault.compartment_id
  display_name          = var.mek_display_name
  key_shape {
    algorithm = var.mek_algorithm
    length    = var.mek_length
  }
  protection_mode       = var.mek_protection_mode
  management_endpoint   = local.selected_vault.management_endpoint
  #depends_on            = var.use_existing_vault ? [oci_kms_vault.devops_vault_existing] : [oci_kms_vault.devops_vault]
}

resource "oci_kms_key" "sign_mek" {
  compartment_id        = local.selected_vault.compartment_id
  display_name          = var.sign_mek_display_name
  key_shape {
    algorithm = var.sign_mek_algorithm
    length    = var.sign_mek_length
  }
  protection_mode       = var.sign_mek_protection_mode
  management_endpoint   = local.selected_vault.management_endpoint
  depends_on            = [oci_kms_vault.devops_vault]
}


resource "oci_vault_secret" "ocirtoken" {
  compartment_id = local.selected_vault.compartment_id
  key_id         = oci_kms_key.default_mek.id
  secret_content {
    content_type = "BASE64"

    content = base64encode(oci_identity_auth_token.auth_token.token)
    # name    = "${var.cert_secret_name}-${var.environment}"
  }
  secret_name = var.ocir_token_secret_name
  description = "Auth token for OCIR docker login/pull/push"
  vault_id    = local.selected_vault.id
}

# Generates User Auth Token # check the limit before creating multiple.
resource "oci_identity_auth_token" "auth_token" {
    #Required
    description = "Auth token for OCIR docker login/pull/push operations"
    user_id = var.user_ocid
}


############# Knoweledge Base ###############
resource "oci_adm_knowledge_base" "knowledge_base" {
    compartment_id = var.compartment_id
    display_name = var.knowledge_base_display_name
}

