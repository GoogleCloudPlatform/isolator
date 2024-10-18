/**
 * Copyright 2024 The Isolator Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/******************************************
  Org Node IAM for Isolator
 *****************************************/

# This is an example. It is HIGHLY recommended to manage org node IAM
# authoritatively
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_organization_iam

#resource "google_organization_iam_member" "org_policy_admin" {
#  member = "serviceAccount:${var.sa_02_org_policies}"
#  org_id = var.organization_id
#  role   = "roles/orgpolicy.policyAdmin"
#}

/******************************************
  For HFW Rules Mgmt At Folder Level
 *****************************************/

# The below permission is required by identities that manage HFW rules for folders
# Because only the one permission is required it is added to a custom role
# rather than assigning a predefined role which contains it as that would be
# over permissive.

resource "google_organization_iam_custom_role" "hierarchical_firewall_rule_manager" {
  org_id      = var.organization_id
  permissions = [
    "compute.globalOperations.get"
  ]
  role_id     = "hfw_rule_manager_global_op_get"
  title       = "Hierarchical Firewall Rule Global Operations Get"
}


# Again, as above the below is not recommended from an org node IAM perspective
# that should be managed authoritatively. It can help to see how the role is
# referenced though.

resource "google_organization_iam_member" "org_node_hfw_custom_role" {
  member = "serviceAccount:${var.sa_05_security_project_resources}"
  org_id = var.organization_id
  role   = google_organization_iam_custom_role.hierarchical_firewall_rule_manager.id
}