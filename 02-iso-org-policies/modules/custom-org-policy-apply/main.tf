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
  Apply an Organization Policy to a Folder
*****************************************/

# ===================================================================================
# Resource: google_org_policy_policy
# Purpose: This resource applies one or more existing organization policies to the
#          specified folder. It iterates over the `var.constraints_to_apply`
#          list, creating a policy enforcement for each item.
# ===================================================================================
resource "google_org_policy_policy" "custom_org_policy" {
  for_each = toset(var.constraints_to_apply)
  name   = "folders/${var.folder_id}/policies/custom.${each.value}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}