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
  type        = string
  description = "The ID of the organization where the custom constraint will be created."
}

variable "constraint_name" {
  type        = string
  description = "The name of the custom constraint, e.g., 'gkeRestrictDefaultSa'."
}

variable "display_name" {
  type        = string
  description = "The human-readable name of the policy."
}

variable "description" {
  type        = string
  description = "A detailed description of what the policy enforces."
}

variable "condition" {
  type        = string
  description = "The CEL condition that triggers the policy's action."
}

variable "resource_types" {
  type        = list(string)
  description = "The list of GCP resource types this constraint applies to."
}

variable "action_type" {
  type = string
  description = "The action. Either 'DENY' or 'ALLOW'"
  default = "DENY"
}

variable "method_types" {
  type = list(string)
  description = "The method types. 'CREATE', 'UPDATE'. Default is both"
  default = [
    "CREATE",
    "UPDATE"
  ]
}