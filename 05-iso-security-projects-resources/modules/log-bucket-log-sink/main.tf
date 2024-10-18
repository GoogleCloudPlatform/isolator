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
  Log Bucket
 *****************************************/
resource "google_logging_project_bucket_config" "isolator_log_bucket" {
  bucket_id = "${var.log_bucket_name}-${random_string.log_bucket_name_random_string.result}"
  location  = "us"
  project   = var.project_id
  retention_days   = 30
  enable_analytics = true
  locked           = true
}

resource "random_string" "log_bucket_name_random_string" {
  length  = 4
  lower   = true
  upper   = false
  special = false
  numeric = true
}

/******************************************
  Folder Log Sink
 *****************************************/
resource "google_logging_folder_sink" "isolator_log_bucket_log_sink" {
  depends_on       = [google_logging_project_bucket_config.isolator_log_bucket]
  destination      = "logging.googleapis.com/${google_logging_project_bucket_config.isolator_log_bucket.id}"
  folder           = var.folder_id
  name             = "${var.log_bucket_name}-sink"
  include_children = true
  filter           = var.log_sinks_filter
}

/******************************************
  Log Sink - IAM Permission
 *****************************************/
resource "google_project_iam_member" "isolator_folder_sink_log_bucket_log_writer" {
  depends_on = [google_logging_folder_sink.isolator_log_bucket_log_sink]
  member     = google_logging_folder_sink.isolator_log_bucket_log_sink.writer_identity
  project    = var.project_id
  role       = "roles/logging.bucketWriter"
}
