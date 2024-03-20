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