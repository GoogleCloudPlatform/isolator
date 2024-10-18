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
  Locals
 *****************************************/



locals {
  # This is the project ID for the Isolator security log project
  # This project is created as part of the 05 Security Projects pipeline
  isolator_logs_and_monitoring_project_id = "tst24-iso-sec-log-7unz"

  # This access policy will need to be created by the team which manages
  # Access Context Manager (VPC Service Controls) permissions from the Org Node
  # Per the Isolator designs and implementation guide this is the policy that
  # will be scoped to the Isolator folder.

  isolator_access_policy = "57022806392"

  # This is the names of the sink being configured
  # The names can stay the same as provided here or may be updated if necessary
  isolator_org_node_log_bucket_log_sink_name = "isolator-log-bucket-log-sink-org-node"

  # This may be found in the Isolator logs and monitoring project
  # It may be viewed as an output from the 05 Security Resources pipeline
  isolator_log_bucket_name = "iso-sec-logs-dx6u"

  # This filter scopes the logs collected from the Org Node to only include
  # Access Context Manager logs for the scoped Isolator Access Policy and the
  # logs for this sink itself.
  # While it would be nice to reference to our google_logging_organization_sink
  # and use the output to generate the filter for the log sink resource name
  # This would be circular because the filter is included in the resource block
  # itself, and Terraform will give an error. Therefore, we will need
  # to construct it as we have here where we use our local inputs to build
  # what we know the name of the sink will be.
  isolator_log_filter = "(protoPayload.serviceName=\"accesscontextmanager.googleapis.com\" AND protoPayload.resourceName:\"accessPolicies/${local.isolator_access_policy}\") OR protoPayload.resourceName:\"organizations/${var.organization_id}/sinks/${local.isolator_org_node_log_bucket_log_sink_name}\""

  # The id the target log bucket for this sink
  # The format entered should follow:
  # "projects/{isolator_logs_and_monitoring_project_id}/locations/{bucket_location}/buckets/{bucket_name}"
  # If variables were not changed in the creation of this bucket (05 Security Resources)
  # then below may be used
  isolator_log_bucket_id = "projects/${local.isolator_logs_and_monitoring_project_id}/locations/us/buckets/${local.isolator_log_bucket_name}"

  # This is the target pubsub topic for this sink. This is for alerting
  # The following format is expected:
  # pubsub.googleapis.com/projects/[PROJECT_ID]/topics/[TOPIC_ID]
  isolator_pub_sub_topic_id = "log-alerts-pubsub"
}

/******************************************
  Isolator Org Log Sink - To Logging Bucket
 *****************************************/
resource "google_logging_organization_sink" "isolator_log_bucket_log_sink_org_node" {
  destination      = "logging.googleapis.com/${local.isolator_log_bucket_id}"
  name             = local.isolator_org_node_log_bucket_log_sink_name
  org_id           = var.organization_id
  include_children = false
  filter           = local.isolator_log_filter
}

/******************************************
  Isolator Log Sink - To PubSub (Alerting)
 *****************************************/
resource "google_logging_organization_sink" "isolator_vpc_sc_change_alerting" {
  name        = "isolator-vpc-sc-change"
  description = "Filters and sends any logs of Isolator VPC SC Change"
  org_id      = var.organization_id

  # Export to pubsub
  destination = "pubsub.googleapis.com/projects/${local.isolator_logs_and_monitoring_project_id}/topics/${local.isolator_pub_sub_topic_id}"
  filter      = "(protoPayload.serviceName=\"accesscontextmanager.googleapis.com\" AND protoPayload.resourceName:\"accessPolicies/${local.isolator_access_policy}\") AND (protoPayload.methodName:\"AccessContextManager.UpdateServicePerimeter\" OR protoPayload.methodName:\"AccessContextManager.DeleteServicePerimeter\" OR protoPayload.methodName:\"AccessContextManager.CreateServicePerimeter\")"

  include_children = true
}

