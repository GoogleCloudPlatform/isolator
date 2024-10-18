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
  Input Variables
 *****************************************/
# If not prefix is required then remove this variable. You need to remove the reference to it in the project name/id
# If you do remove this from the project name/id, don't forget to remove the - as well so it doesnt' start with a -
variable "project_prefix" {
  description = "If a prefix is required it may be entered here. Limit is 6 characters."
  type        = string
}

variable "folder_id" {
  description = "The folder ID of where the project will reside."
  type        = string
}

variable "billing_account_id" {
  description = "Billing Account ID where costs of the project will be charged."
  type        = string
}

variable "logs_resource_sa" {
  description = "The GCP Service Account which will run the pipeline that creates the log related resources in this project."
  type        = string
}

variable "isolator_security_admins_group" {
  description = "The group for Isolator security admins"
  type        = string
}
