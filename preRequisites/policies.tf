variable "dynamic_group_name" {
    default = "cicd-devops-dg1"
}
variable "dynamic_group_description" {
    default = "Dynamic group to provide access to Devops project resources"
}

variable "dynamic_group_matching_rule" {
    default = "All {resource.compartment.id = 'ocid1.compartment.oc1..aaaaaaaaxcuuupi5or6vcu242qdm4iit4vwigbwke2kdjksfzrbksbrq6tia', Any {resource.type = 'devopsdeploypipeline', resource.type = 'devopsbuildpipeline', resource.type = 'devopsrepository', resource.type = 'devopsconnection', resource.type = 'devopstrigger'}}"
}

variable "dynamic_group_policy_name" {
    default = "cicd-devops-policy1"
}

variable "dynamic_group_policy_description" {
    default = "Dynamic group policy to provide access to Devops project resources dynamic group"
}
variable "dynamic_group_policy_statements" {
    type    = list(string)
    default = [
    "define compartment fsretools_test_dp_business_logic as ocid1.compartment.oc1..aaaaaaaaxcuuupi5or6vcu242qdm4iit4vwigbwke2kdjksfzrbksbrq6tia",
    "Allow dynamic-group cicd-devops-dg to read secret-family in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to use ons-topics in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to use adm-knowledge-bases in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to use devops-family in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to manage adm-vulnerability-audits in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to use subnets in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to use vnics in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to use network-security-groups in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to use cabundles in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to read all-artifacts in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to manage virtual-network-family in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to manage cluster-family in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to manage repos in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to manage generic-artifacts in compartment fsretools_test_dp_business_logic",
    "Allow service vulnerability-scanning-service to read repos in compartment  fsretools_test_dp_business_logic",
    "Allow service vulnerability-scanning-service to read compartments in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to manage all-artifacts in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to manage ons-topics in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to manage all-resources in compartment fsretools_test_dp_business_logic",
    "Allow dynamic-group cicd-devops-dg to manage all-resources in tenancy",
    "Allow dynamic-group cicd-devops-dg to manage key-family in compartment fsretools_test_dp_business_logic"
    ]
}

resource "oci_identity_dynamic_group" "cicd_devops_dg" {
    #Required
    compartment_id = var.tenancy_ocid # dynamic group created at tenancy level
    description = var.dynamic_group_description
    matching_rule = var.dynamic_group_matching_rule
    name = var.dynamic_group_name
}
resource "oci_identity_policy" "cicd_devops_dg_policies" {
  name           = var.dynamic_group_policy_name
  description    = var.dynamic_group_policy_description
  compartment_id = var.tenancy_ocid # polcies created at tenancy level.
  statements     = var.dynamic_group_policy_statements
  depends_on = [oci_identity_dynamic_group.cicd_devops_dg]
}