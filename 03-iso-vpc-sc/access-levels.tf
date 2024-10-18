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
  Access Levels
 *****************************************/
# Isolator Device Rules
# Requires a minimum browser version for Chrome
# Not used directly, will be combined in access level below with other requirements
resource "google_access_context_manager_access_level" "chrome_browser_minimum_version" {
  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/accessLevels/chrome_browser_minimum_version"
  title  = "chrome_browser_minimum_version"
  custom {
    expr {
      expression = "device.chrome.versionAtLeast('${var.required_minimum_chrome_version}')"
    }
  }
}

# Requires Chrome browser to be managed
# Not used directly, will be combined in access level below with other requirements
resource "google_access_context_manager_access_level" "managed_chrome_browser" {
  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/accessLevels/managed_chrome_browser"
  title  = "managed_chrome_browser"
  custom {
    expr {
      expression = "device.chrome.management_state == ChromeManagementState.CHROME_MANAGEMENT_STATE_BROWSER_MANAGED"
    }
  }
}

# Requires BCE Corp managed device
# Not used directly, will be combined in access level below with other requirements
resource "google_access_context_manager_access_level" "bce_corp_owned_device" {
  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/accessLevels/bce_corp_owned_device"
  title  = "bce_corp_owned_device"
  custom {
    expr {
      expression  = "device.is_corp_owned_device == true"
    }
  }
}

# Combines the above device policies into one policy that requires they are all met
# This is the access level to be referenced in the Ingress rules for our perimeter
resource "google_access_context_manager_access_level" "meets_all_isolator_device_conditions" {
  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/accessLevels/meets_all_isolator_device_conditions"
  title  = "meets_all_isolator_device_conditions"
  basic {
    combining_function = "AND"
    conditions {
      required_access_levels = [
        google_access_context_manager_access_level.chrome_browser_minimum_version.name,
        google_access_context_manager_access_level.managed_chrome_browser.name,
        google_access_context_manager_access_level.bce_corp_owned_device.name,
      ]
    }
  }
}