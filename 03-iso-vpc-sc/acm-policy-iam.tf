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
  Access Context Manager IAM Policies
 *****************************************/
# Adding Policy Reader role for Security Team 
resource "google_access_context_manager_access_policy_iam_member" "isolator_vpc_sc_poc_security_group_member_policyreader" {
  name   = "accessPolicies/${var.access_policy_name}"
  role   = "roles/accesscontextmanager.policyReader"
  member = "group:${var.grp_isolator_partner_security_team}"
}

# Adding VPCSC Trouble Shooter Viewer role for Security Team 
resource "google_access_context_manager_access_policy_iam_member" "isolator_vpc_sc_poc_security_group_member_troubleshooter" {
  name   = "accessPolicies/${var.access_policy_name}"
  role   = "roles/accesscontextmanager.vpcScTroubleshooterViewer"
  member = "group:${var.grp_isolator_partner_security_team}"
}