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
variable "organization_id" {
  description = "The Google Cloud Organization ID for the host organization."
}

variable "billing_account_id" {
  description = "Billing Account ID of Google Cloud billing account which will be associated with Isolator projects."
  type        = string
}

variable "isolator_parent_folder_id" {
  description = "If Isolator is not directly under the org node, this is the folder ID of the folder under which Isolator will sit"
  type        = string
}

# Note the creation of this folder is included in this folder as its
# a pre req. Technically it can be referenced by referencing the resource
# but it is NOT recommended to deploy all these resources from the same pipeline
variable "isolator_folder_id" {
  description = "The Google Cloud Folder ID for the folder created for the Isolator environment"
}

# Service Accounts
variable "sa_01_resource_hierarchy" {
  description = "The GCP Service Account used by the Isolator Resource Hierarchy pipeline."
  type        = string
}
variable "sa_02_org_policies" {
  description = "The GCP Service Account used by the Isolator Organization Policy pipeline."
  type        = string
}
variable "sa_03_vpc_sc" {
  description = "The GCP Service Account used by the Isolator VPC Service Controls pipeline."
  type        = string
}
variable "sa_04_security_projects" {
  description = "The GCP Service Account used by the pipeline that creates Isolator security projects."
  type        = string
}
variable "sa_05_security_project_resources" {
  description = "The GCP Service Account used by the pipeline that creates Isolator security project resources."
  type        = string
}
variable "sa_06_data_projects" {
  description = "The GCP Service Account used by the pipeline that creates Isolator data projects."
  type        = string
}
variable "sa_07_data_projects_resources" {
  description = "The GCP Service Account used by the pipeline that creates Isolator data project resources."
  type        = string
}