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
  Scoped Policy for Isolator
 *****************************************/
# Scoped Policy (set up at the folder level)
resource "google_access_context_manager_access_policy" "isolator_vpcsc_scoped_policy" {
  parent = "organizations/${var.organization_id}"
  title  = "Isolator Scoped Policy"
  scopes = ["folders/${var.isolator_folder_id}"]
}

# Add the IAM Members to manage this scoped policy
resource "google_access_context_manager_access_policy_iam_member" "isolator_vpc_sc_poc_pipeline_member" {
  name = google_access_context_manager_access_policy.isolator_vpcsc_scoped_policy.name
  role = "roles/accesscontextmanager.policyAdmin"
  member = "serviceAccount:${var.sa_03_vpc_sc}"
}