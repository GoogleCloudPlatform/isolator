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
  Org Policy
 *****************************************/

locals {
  constraints_map = toset(var.constraint_list)
}

resource "google_org_policy_policy" "folder_policy" {
  for_each = local.constraints_map
  name     = "folders/${var.folder_id}/policies/${each.value}"
  parent   = "folders/${var.folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      enforce = var.constraint_value
    }
  }
}