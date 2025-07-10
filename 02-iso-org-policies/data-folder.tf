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
#/******************************************
#  Data Folder
# *****************************************/

####################################################################
# Compute Engine
####################################################################
resource "google_org_policy_policy" "isolator_data_folder_restrict_vpc_peering" {
  name   = "folders/${local.data_folder_id}/policies/compute.restrictVpcPeering"
  parent = "folders/${local.data_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "under:folders/${local.data_folder_id}",
          # https://autonomousthingz-life.medium.com/google-cloud-organisation-policies-get-the-restrict-vpc-peering-usage-organisation-policy-d87dce84a5e7
          "under:folders/832634261155",
          "under:folders/1087601843002",
          "under:folders/391150242170",
        ]
      }
    }
  }
}

# https://cloud.google.com/vpc/docs/private-service-connect-security#org-policies
resource "google_org_policy_policy" "isolator_data_folder_restrict_psc_producer" {
  name   = "folders/${local.data_folder_id}/policies/compute.restrictPrivateServiceConnectProducer"
  parent = "folders/${local.data_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "under:folders/${local.data_folder_id}",
          # https://cloud.google.com/vpc/docs/manage-security-private-service-connect-consumers
          "under:organizations/433637338589",
        ]
      }
    }
  }
}

# https://cloud.google.com/vpc/docs/private-service-connect-security#org-policies
resource "google_org_policy_policy" "isolator_data_folder_restrict_psc_consumer" {
  name   = "folders/${local.data_folder_id}/policies/compute.restrictPrivateServiceConnectConsumer"
  parent = "folders/${local.data_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "under:folders/${local.data_folder_id}",
        ]
      }
    }
  }
}

resource "google_org_policy_policy" "isolator_data_folder_gce_restrict_vpc_host_project" {
  name   = "folders/${local.data_folder_id}/policies/compute.restrictSharedVpcHostProjects"
  parent = "folders/${local.data_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "under:folders/${local.data_folder_id}",
        ]
      }
    }
  }
}

resource "google_org_policy_policy" "isolator_data_folder_gce_restrict_storage_use" {
  name   = "folders/${local.data_folder_id}/policies/compute.storageResourceUseRestrictions"
  parent = "folders/${local.data_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "under:folders/${local.data_folder_id}",
        ]
      }
    }
  }
}

####################################################################
# Vertex AI Workbench
####################################################################
resource "google_org_policy_policy" "isolator_data_folder_vertex_workbench_restrict_vpc_networks" {
  name   = "folders/${local.data_folder_id}/policies/ainotebooks.restrictVpcNetworks"
  parent = "folders/${local.data_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "under:folders/${local.data_folder_id}",
        ]
      }
    }
  }
}