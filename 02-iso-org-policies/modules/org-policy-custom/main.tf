/**
 * Copyright 2025 The Isolator Authors
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
  Org Policies - Custom - Cloud Build
 *****************************************/
# Restrict Worker Pool Public Egress
resource "google_org_policy_custom_constraint" "cloud_build_no_public_egress" {
  name         = "custom.restrictCloudBuildPublicEgress"
  parent       = "organizations/${var.organization_id}"
  display_name = "Restrict the use of public Egress for Cloud Build Worker Pools"
  description  = "Cloud Build worker pools can be configured to have public egress. This policy restricts Cloud Build Worker Pools from deploying with public egress."
  # Setting "ALLOW"as this essentially means all other values are "DENY"
  # There are two other values that both make it public
  # https://cloud.google.com/build/docs/api/reference/rest/v1/projects.locations.workerPools#egressoption
  action_type  = "ALLOW"
  condition    = "resource.privatePoolV1Config.networkConfig.egressOption == \"NO_PUBLIC_EGRESS\""
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "cloudbuild.googleapis.com/WorkerPool",
  ]
}

resource "google_org_policy_policy" "cloud_build_no_public_egress" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.cloud_build_no_public_egress.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}
