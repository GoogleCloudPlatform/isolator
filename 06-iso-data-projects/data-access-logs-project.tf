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
  Data Access Logs Project
 *****************************************/
module "data_access_logs_project" {
  source             = "./modules/data-access-logs-project"
  project_prefix     = var.project_unique_prefix
  folder_id          = local.data_folder_id
  billing_account_id = var.billing_account_id
  logs_resource_sa   = var.sa_05_security_project_resources
}
