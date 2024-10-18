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
  Isolator Org Node Log Sink - Writer Identity Permission
 *****************************************/
#TODO Uncomment below after creating org node log sinks
#resource "google_project_iam_member" "isolator_org_node_sink_log_bucket_log_writer" {
#  member  = "serviceAccount:service-org-${var.isolator_org_id}@gcp-sa-logging.iam.gserviceaccount.com"
#  project = local.security_log_project_id
#  role    = "roles/logging.bucketWriter"
#}
#
#resource "google_pubsub_topic_iam_member" "isolator_org_node_sink_pubsub_log_writer" {
#  project = local.security_log_project_id
#  topic = module.security_log_monitoring.pub_sub_topic_id
#  role    = "roles/pubsub.publisher"
#  member  = "serviceAccount:service-org-${var.isolator_org_id}@gcp-sa-logging.iam.gserviceaccount.com"
#}

/******************************************
  Isolator Security - Log Bucket & Log Sink
 *****************************************/
module "security_log_bucket_and_sink" {
  source           = "./modules/log-bucket-log-sink"
  project_id       = local.security_log_project_id
  folder_id        = var.isolator_folder_id
  log_sinks_filter = local.isolator_security_logs_sink_filter
  log_bucket_name  = "iso-sec-logs"
}

# The below module creates an empty GCS bucket with a lock. The reason for this
# is that a locked GCS bucket will automatically add a lien to a project
# https://cloud.google.com/storage/docs/bucket-lock#policy-locks
# This lien will help protect against accidental deletion (e.g. comment out the
# Terraform and run an apply). It has the benefit of auto adding the lien so that the
# pipeline SA does not have permission to delete or remove the lien by default
# Thus project deletion will require multiple steps and intervention to be deleted
# This helps ensure the project is deleted purposefully.
# While we could then just use GCS as our destination for the log sink, searching
# through logs in GCS is not as user friendly as using the log explorer.

module "empty_gcs_bucket_security_logs_project" {
  source     = "./modules/empty-gcs-prj-lien"
  project_id = local.security_log_project_id
}

/******************************************
  Isolator Data Access Logs - Log Bucket & Log Sink
 *****************************************/

#TODO: Uncomment after the 06 project creates the data access logs project
# module "data_access_log_bucket_and_sink" {
#   source           = "./modules/log-bucket-log-sink"
#   project_id       = local.data_access_logs_log_project_id
#   folder_id        = var.isolator_folder_id
#   log_sinks_filter = local.isolator_data_access_logs_sink_filter
#   log_bucket_name  = "iso-data-logs"
# }

# The below module creates an empty GCS bucket with a lock. The reason for this
# is that a locked GCS bucket will automatically add a lien to a project
# https://cloud.google.com/storage/docs/bucket-lock#policy-locks
# This lien will help protect against accidental deletion (e.g. comment out the
# Terraform and run an apply). It has the benefit of auto adding the lien so that the
# pipeline SA does not have permission to delete or remove the lien by default
# Thus project deletion will require multiple steps and intervention to be deleted
# This helps ensure the project is deleted purposefully.
# While we could then just use GCS as our destination for the log sink, searching
# through logs in GCS is not as user friendly as using the log explorer.

#TODO: Uncomment after the 06 project creates the data access logs project
# module "empty_gcs_bucket_data_access_logs_project" {
#   source     = "./modules/empty-gcs-prj-lien"
#   project_id = local.data_access_logs_log_project_id
# }
