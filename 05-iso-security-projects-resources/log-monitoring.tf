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
  Isolator Security - Log Monitoring
 *****************************************/
module "security_log_monitoring" {
  source                     = "./modules/log-monitor-alerts"
  project_id                 = local.security_log_project_id
  isolator_folder_id         = var.isolator_folder_id
  isolator_org_id            = var.isolator_org_id
  grp_isolator_security_team = var.grp_isolator_partner_security_team_external
}
