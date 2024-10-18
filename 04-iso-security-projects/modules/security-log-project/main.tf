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
  Project Creation
 *****************************************/
module "isolator_security_log_project" {
  source                 = "../project-creation"
  billing_account_id     = var.billing_account_id
  project_type           = "sec"
  folder_id              = var.folder_id
  project_prefix         = var.project_prefix
  project_unique_purpose = "log"
  apis_to_enable         = local.apis_to_enable
}

locals {
  logs_sa_iam_roles = toset(local.logs_sa_role_list)
  grp_iam_roles     = toset(local.grp_role_list)

  apis_to_enable = [
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "storage.googleapis.com",
    "pubsub.googleapis.com",
  ]

  logs_sa_role_list = [
    "roles/monitoring.admin",
    "roles/logging.admin",
    "roles/storage.admin",
    "roles/pubsub.admin"
  ]

  grp_role_list = [
    "roles/logging.viewer",
    "roles/logging.privateLogViewer",
    "roles/monitoring.viewer",
    "roles/pubsub.subscriber",
    "roles/pubsub.viewer",
  ]
}

/******************************************
  IAM
 *****************************************/
resource "google_project_iam_member" "isolator_security_logs_sa_permissions" {
  for_each = local.logs_sa_iam_roles
  project  = module.isolator_security_log_project.project_id
  member   = "serviceAccount:${var.logs_resource_sa}"
  role     = each.value
}

resource "google_project_iam_member" "isolator_security_pipeline_security_admins_permissions" {
  for_each = local.grp_iam_roles
  project  = module.isolator_security_log_project.project_id
  member   = "group:${var.isolator_security_admins_group}"
  role     = each.value
}

/******************************************
  Limited IAM Admin Permissions
 *****************************************/
resource "google_project_iam_member" "limited_iam_admin_for_log_sink_pipeline_sa" {
  project = module.isolator_security_log_project.project_id
  member  = "serviceAccount:${var.logs_resource_sa}"
  role    = "roles/resourcemanager.projectIamAdmin"

  condition {
    expression = "api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly(['roles/logging.bucketWriter'])"
    title      = "limited_iam_admin_restrictions"
  }
}
