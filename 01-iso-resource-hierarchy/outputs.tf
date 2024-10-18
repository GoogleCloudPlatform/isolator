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
  Outputs
 *****************************************/
output "data_folder_id" {
  value = google_folder.isolator_data.folder_id
}

output "security_folder_id" {
  value = google_folder.isolator_security.folder_id
}

# This is an key output for the VPC Service Control perimeter
# The two list outputs below will be used by the VPC SC perimeters to scan for projects under these folders
# Any projects found will be put in the respective list's perimeter.
# Unfortunately the tool does not recursively scan folders under each other, so every folder must be listed
output "security_folder_id_list" {
  value = [
    google_folder.isolator_security.folder_id,
  ]
}

output "data_folder_id_list" {
  value = [
    google_folder.isolator_data.folder_id,
  ]
}