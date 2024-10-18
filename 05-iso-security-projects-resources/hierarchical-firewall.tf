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
  Isolator Folder
 *****************************************/
module "hierarchical_firewall" {
  source             = "./modules/hierarchical-firewall"
  isolator_folder_id = var.isolator_folder_id
  data_folder_id     = local.data_folder_id
  security_folder_id = local.security_folder_id
}
