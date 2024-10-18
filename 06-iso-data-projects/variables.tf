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
  Variables
 *****************************************/
# Service Accounts
variable "sa_05_security_project_resources" {
  description = "The GCP Service Account used by the pipeline that creates Isolator security project resources."
  type        = string
}

# Project related variables
variable "project_unique_prefix" {
  description = "Unique prefix as required by customer. Up to 6 characters"
  type        = string
}
variable "billing_account_id" {
  description = "Billing Account ID of Google Cloud billing account which will be associated with projects."
  type        = string
}
