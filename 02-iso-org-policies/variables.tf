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

variable "organization_id" {
  description = "The Google Cloud Organization ID for the organization."
}

variable "domain_identities" {
  description = "Root domain identities. Allows all users with identity in domain to see org node. Helps users know they are working within appropriate space"
  type        = list(string)
}

variable "domain_contacts" {
  type = list(string)
}

variable "allowed_locations" {
  description = "Used for org policy constraint to limit resource location"
  type        = list(string)
  default = [
    "in:us-locations",
  ]
}

variable "service_account_expiry" {
  description = "Allowed values for GCP Service Account key expiration"
  type        = list(string)
}

variable "custom_constraints_to_apply" {
  description = "A list of the custom constraints to apply to the Isolator Folder. Do not include 'custom.' in the names of these."
  type = list(string)
}