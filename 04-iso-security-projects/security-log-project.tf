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
  Security Projects - Log Monitor Project
 *****************************************/
module "isolator_security_log_project" {
  source             = "./modules/security-log-project"
  billing_account_id = var.billing_account_id
  folder_id          = local.security_folder_id
  project_prefix     = var.project_unique_prefix

  logs_resource_sa               = var.sa_05_security_project_resources
  isolator_security_admins_group = var.grp_isolator_partner_security_admins
}
