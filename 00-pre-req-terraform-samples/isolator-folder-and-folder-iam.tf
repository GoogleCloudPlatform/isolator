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
  Isolator -If directly under Org Node
 *****************************************/
# Folder Creation
resource "google_folder" "isolator_under_org_node" {
  display_name = "Isolator-Oct2024"
  parent       = "organizations/${var.organization_id}"
}

# Pre-Req IAM Assignment
resource "google_folder_iam_member" "isolator_sa_folder_admin" {
  folder = google_folder.isolator_under_org_node.folder_id
  member = "serviceAccount:${var.sa_01_resource_hierarchy}"
  role   = "roles/resourcemanager.folderAdmin"
}


/******************************************
  Isolator - If under folder (Rather than org node)
 *****************************************/
## Folder Creation
#resource "google_folder" "isolator_under_folder" {
#  display_name = "Isolator"
#  parent       = "folders/${var.isolator_parent_folder_id}"
#}
#
## Pre-Req IAM Assignment
#resource "google_folder_iam_member" "isolator_sa_folder_admin" {
#  folder = google_folder.isolator_under_org_node.folder_id
#  member = "serviceAccount:${var.sa_01_resource_hierarchy}"
#  role   = "roles/resourcemanager.folderAdmin"
#}
