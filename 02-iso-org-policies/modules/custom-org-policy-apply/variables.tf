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

# The ID of the target resource (folder or project) where the policies will be applied.
variable "folder_id" {
  description = "The numeric ID of the folder or the string ID of the project to apply the policy to."
  type        = string
}

# A list of organization policy constraints to apply and enforce on the target.
# These must be the full constraint names (e.g., 'iam.allowedPolicyMemberDomains' or 'custom.gkeRequireCos').
variable "constraints_to_apply" {
  description = "A list of the full names of the constraints to enforce on the target resource."
  type        = list(string)
}