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
  description = "The GCP Service Account used by the pipeline that creates Isolator data project resoureces."
  type        = string
}

# Groups
# Note this group is for the Isolator Partner security team. It is assumed the
# Isolator Host security team already has required access to the environment from
# higher in the Google Cloud resource hierarchy.
variable "grp_isolator_partner_security_admins" {
  description = "The group that will contain the Isolator Partner Security Team."
}