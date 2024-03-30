# Define your input variables here
########### TOPIC ################
variable "notification_topic_description" {
  default = "Topic for OCI Devops Porject"
  type    = string
}

variable "notification_topic_name" {
  default     = "ocidevops_topic"
  description = "The name of the notification topic to be used for OCI DevOps. This topic will be utilized for publishing notifications related to CI/CD pipelines, deployments, and other DevOps activities."
  type        = string
}

############ VAULT ###################
variable "vault_name" {
  description = "The name of the vault to be created or managed by Terraform. This vault will be used to securely store and manage sensitive data such as passwords, API keys, and certificates."
  type        = string
  default     = "fsretools_vault"
}

variable "vault_type" {
  description = "The type of vault to be created or managed by Terraform. This determines the configuration and capabilities of the vault. Options include 'DEFAULT' for a standard vault and 'VIRTUAL_PRIVATE' for a virtual private vault."
  type        = string
  default     = "DEFAULT" # Options: DEFAULT, VIRTUAL_PRIVATE
}

############ VAULT: MEK (Master Encryption Key) ###################
variable "mek_display_name" {
  description = "The display name for the Terraform-managed Master Encryption Key (MEK) to be created in the OCI KMS service. This key is used for encrypting sensitive data within your Oracle Cloud Infrastructure (OCI) resources."
  type        = string
  default     = "My Terraform MEK"
}

variable "mek_algorithm" {
  description = "The encryption algorithm to be used for the Master Encryption Key (MEK). This determines the cryptographic algorithm used for encryption. Supported algorithms include 'AES' (Advanced Encryption Standard)."
  type        = string
  default     = "AES"
}

variable "mek_length" {
  description = "The length of the encryption key in bits for the Master Encryption Key (MEK). This specifies the size of the cryptographic key used for encryption. For AES, the typical length is '32' bits."
  type        = string
  default     = "32"
}

variable "mek_protection_mode" {
  description = "The protection mode for the Master Encryption Key (MEK). This determines whether the key material is stored in hardware or software. Options include 'SOFTWARE' or 'HSM' (Hardware Security Module)."
  type        = string
  default     = "SOFTWARE"
}

############### VAULT: Sign MEK #############
variable "sign_mek_display_name" {
  description = "The display name for the Terraform-managed OCIR Signing Master Key to be created in the OCI KMS service. This key is used for signing container images within Oracle Cloud Infrastructure Registry (OCIR)."
  type        = string
  default     = "OCIR Signing Master Key"
}

variable "sign_mek_algorithm" {
  description = "The encryption algorithm to be used for the OCIR Signing Master Key. This determines the cryptographic algorithm used for signing container images. Supported algorithms include 'RSA' (Rivest-Shamir-Adleman)."
  type        = string
  default     = "RSA"
}

variable "sign_mek_length" {
  description = "The length of the encryption key in bits for the OCIR Signing Master Key. For RSA, this typically specifies the key size in bits, such as '512' bits for a 512-bit RSA key."
  type        = string
  default     = "512"
}

variable "sign_mek_protection_mode" {
  description = "The protection mode for the OCIR Signing Master Key. This determines whether the key material is stored in hardware or software. Options include 'SOFTWARE' or 'HSM' (Hardware Security Module)."
  type        = string
  default     = "SOFTWARE"
}

############ VAULT: OCIR Token Secret Name ###########
# variables.tf
variable "ocir_token_secret_name" {
    description = "The name of the secret key in the OCI Vault that stores the authentication token for OCIR. This token is used for authentication when logging in to OCIR and for pulling and pushing Docker images."
    type        = string
    default     = "ocir_token"
}

############# Knoweledge Base ###############
variable "knowledge_base_display_name" {
  description = "The display name for the (OCI) Knowledge Base."
  type        = string
  default     = "KB_FSRE_TOOLS"
}
