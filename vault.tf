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

#TODO: need to add secret creation code.

resource "oci_vault_secret" "default_mek" {
  compartment_id = var.compartment_ocid
  key_id         = oci_kms_key.k8s_kms_key.id
  secret_content {
    content_type = "BASE64"

    content = base64encode("empty cert secret")
    # name    = "${var.cert_secret_name}-${var.environment}"
  }
  secret_name = "samplesecret"
  description = "sample secret"
  vault_id    = oci_kms_vault.devops_vault.id
}


# resource "oci_vault_secret" "test_secret" {
#     #Required
#     compartment_id = var.compartment_id
#     secret_content {
#         #Required
#         content_type = var.secret_secret_content_content_type

#         #Optional
#         content = var.secret_secret_content_content
#         name = var.secret_secret_content_name
#         stage = var.secret_secret_content_stage
#     }
#     secret_name = oci_vault_secret.test_secret.name
#     vault_id = oci_kms_vault.test_vault.id

#     #Optional
#     defined_tags = {"Operations.CostCenter"= "42"}
#     description = var.secret_description
#     freeform_tags = {"Department"= "Finance"}
#     key_id = oci_kms_key.test_key.id
#     metadata = var.secret_metadata
#     rotation_config {
#         #Required
#         target_system_details {
#             #Required
#             target_system_type = var.secret_rotation_config_target_system_details_target_system_type

#             #Optional
#             adb_id = oci_vault_adb.test_adb.id
#             function_id = oci_functions_function.test_function.id
#         }

#         #Optional
#         is_scheduled_rotation_enabled = var.secret_rotation_config_is_scheduled_rotation_enabled
#         rotation_interval = var.secret_rotation_config_rotation_interval
#     }
#     secret_content {
#         #Required
#         content_type = var.secret_secret_content_content_type

#         #Optional
#         content = var.secret_secret_content_content
#         name = var.secret_secret_content_name
#         stage = var.secret_secret_content_stage
#     }
#     secret_rules {
#         #Required
#         rule_type = var.secret_secret_rules_rule_type

#         #Optional
#         is_enforced_on_deleted_secret_versions = var.secret_secret_rules_is_enforced_on_deleted_secret_versions
#         is_secret_content_retrieval_blocked_on_expiry = var.secret_secret_rules_is_secret_content_retrieval_blocked_on_expiry
#         secret_version_expiry_interval = var.secret_secret_rules_secret_version_expiry_interval
#         time_of_absolute_expiry = var.secret_secret_rules_time_of_absolute_expiry
#     }
# }