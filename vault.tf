variable "vault_name" {
    default = "mytfvault"
}
variable "vault_type" {
    default = "DEFAULT" #DEFAULT, VIRTUAL_PRIVATE
}
resource "oci_kms_vault" "devops_vault" {
    compartment_id = var.compartment_id
    display_name   = var.vault_name
    vault_type = var.vault_type
}

resource "oci_kms_key" "default_mek" {
    compartment_id = oci_kms_vault.devops_vault.compartment_id
    #vault_id       = oci_kms_vault.devops_vault.id
    display_name   = "My Terraform MEK"
    key_shape {
        #Required
        algorithm = "AES"
        length = "32"
    }
    protection_mode = "SOFTWARE"
    management_endpoint = oci_kms_vault.devops_vault.management_endpoint
    depends_on = [ oci_kms_vault.devops_vault ]
}

resource "oci_kms_key" "sign_mek" {
    compartment_id = oci_kms_vault.devops_vault.compartment_id
    #vault_id       = oci_kms_vault.devops_vault.id
    display_name   = "OCIR Signing Master key"
    key_shape {
        #Required
        algorithm = "RSA"
        length = "512"
    }
    protection_mode = "SOFTWARE"
    management_endpoint = oci_kms_vault.devops_vault.management_endpoint
    depends_on = [ oci_kms_vault.devops_vault ]
}

resource "oci_vault_secret" "ocirtoken" {
  compartment_id = var.compartment_ocid
  key_id         = oci_kms_key.default_mek.id
  secret_content {
    content_type = "BASE64"

    content = base64encode(oci_identity_auth_token.auth_token.token)
    # name    = "${var.cert_secret_name}-${var.environment}"
  }
  secret_name = "ocir_token_terraform"
  description = "Auth token for OCIR docker login/pull/push"
  vault_id    = oci_kms_vault.devops_vault.id
}

resource "oci_identity_auth_token" "auth_token" {
    #Required
    description = "Auth token for OCIR docker login/pull/push operations"
    user_id = var.user_ocid
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