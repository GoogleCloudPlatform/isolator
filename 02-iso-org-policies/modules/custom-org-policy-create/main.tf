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
  Custom Org Policy
 *****************************************/
# Description: This module creates a Google Cloud custom organization constraint
#              and applies a policy to enforce it on a specific folder.
# ===================================================================================
# Resource: Custom Constraint Definition
# Purpose: This resource defines the custom constraint at the organization level.
#          It specifies the condition to check and the resources it applies to.
# ===================================================================================
resource "google_org_policy_custom_constraint" "custom_org_policy" {
  parent         = "organizations/${var.organization_id}"
  name           = "custom.${var.constraint_name}"
  display_name   = var.display_name
  description    = var.description
  condition      = var.condition
  resource_types = var.resource_types

  action_type = var.action_type
  method_types = var.method_types
}