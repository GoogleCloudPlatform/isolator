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
  Locked GCS bucket
 *****************************************/
resource "google_storage_bucket" "sink_bucket" {
  project                     = var.project_id
  location                    = var.bucket_location
  name                        = "empty-bucket-for-lien-${random_string.random_string.result}"
  uniform_bucket_level_access = true
  retention_policy {
    # By locking the bucket (below) it auto applies the lien
    is_locked = true
    # Since the bucket should be empty we don't need a long time for retention
    retention_period = 10
  }
}

resource "random_string" "random_string" {
  length  = 15
  lower   = true
  upper   = false
  special = false
  numeric = true
}
