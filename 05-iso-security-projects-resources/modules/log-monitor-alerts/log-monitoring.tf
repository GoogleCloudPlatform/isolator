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
  Security control changed by user
  Org Policy, IAM Set Policy
 *****************************************/
resource "google_logging_folder_sink" "sec_changed_by_user" {
  name        = "security-policy-changed-by-user"
  description = "Filters and sends any logs of org policy, iam set policy changes to pubsub"
  folder      = var.isolator_folder_id

  # Export to pubsub
  destination = "pubsub.googleapis.com/${google_pubsub_topic.log_alerts_pubsub_topic.id}"
  filter      = "(protoPayload.methodName=\"SetIamPolicy\" OR protoPayload.methodName:\"OrgPolicy.UpdatePolicy\" OR protoPayload.methodName:\"AccessContextManager.UpdateServicePerimeter\" OR protoPayload.methodName:\"OrgPolicy.DeletePolicy\" OR protoPayload.methodName:\"OrgPolicy.CreatePolicy\") AND NOT protoPayload.authenticationInfo.principalEmail:\".gserviceaccount.com\""

  include_children = true
}

/******************************************
  IAM Change to Group
 *****************************************/
resource "google_logging_folder_sink" "grp_iam_change" {
  name        = "set-iam-group-change"
  description = "Filters and sends any logs of IAM Change to Group"
  folder      = var.isolator_folder_id

  # Export to pubsub
  destination = "pubsub.googleapis.com/${google_pubsub_topic.log_alerts_pubsub_topic.id}"
  filter      = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.bindingDeltas.member:\"group:\""

  include_children = true
}

/******************************************
  Set IAM Policy by Service Account
 *****************************************/
resource "google_logging_folder_sink" "iam_change_sa" {
  name        = "set-iam-policy-by-sa"
  description = "Filters and sends any logs of set IAM Policy by Service Account"
  folder      = var.isolator_folder_id

  # Export to pubsub
  destination = "pubsub.googleapis.com/${google_pubsub_topic.log_alerts_pubsub_topic.id}"
  filter      = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.authenticationInfo.principalEmail:\".gserviceaccount.com\""

  include_children = true
}

/******************************************
  Org Policy Changed by Service Account
 *****************************************/
resource "google_logging_folder_sink" "org_policy_change_sa" {
  name        = "org-policy-changed-by-sa"
  description = "Filters and sends any logs of Org Policy Changed by Service Account"
  folder      = var.isolator_folder_id

  # Export to pubsub
  destination = "pubsub.googleapis.com/${google_pubsub_topic.log_alerts_pubsub_topic.id}"
  filter      = "(protoPayload.methodName:\"OrgPolicy.UpdatePolicy\" OR protoPayload.methodName:\"OrgPolicy.DeletePolicy\" OR protoPayload.methodName:\"OrgPolicy.CreatePolicy\") AND protoPayload.authenticationInfo.principalEmail:\".gserviceaccount.com\""

  include_children = true
}
