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
variable "project_id" {
  description = "The project which will host the Log Bucket."
  type        = string
}

variable "message_storage_region" {
  description = "The name of the log bucket"
  type        = list(string)
  default     = ["us-central1"]
}

variable "message_retention_time" {
  description = "The name of the log bucket"
  type        = string
  default     = "2678000s" #Maximum is 31 days and this this around that.
}

variable "isolator_folder_id" {
  description = "The Folder ID of the folder where the sink will be created."
  type        = string
}

variable "isolator_org_id" {
  description = "The Folder ID of the folder where the sink will be created."
  type        = string
}

variable "grp_isolator_security_team" {
  description = "The group that will contain the Isolator Security Admins."
}
