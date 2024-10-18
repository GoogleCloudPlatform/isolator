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

locals {
  security_folder_id = data.terraform_remote_state.rs_01_iso_resource_hierarchy.outputs.security_folder_id
  data_folder_id     = data.terraform_remote_state.rs_01_iso_resource_hierarchy.outputs.data_folder_id

  security_log_project_id         = data.terraform_remote_state.rs_04_iso_security_projects.outputs.project_ids.security_log
  # TODO: Uncomment below after running 06 pipeline
  # data_access_logs_log_project_id = data.terraform_remote_state.rs_06_iso_data_projects.outputs.project_ids.data_access_logs

  # To help with filter creation:
  # https://cloud.google.com/architecture/security-log-analytics#log_scoping_tool
  isolator_security_logs_sink_filter    = "LOG_ID(\"cloudaudit.googleapis.com/policy\") OR LOG_ID(\"cloudaudit.googleapis.com/activity\") OR LOG_ID(\"externalaudit.googleapis.com/activity\") OR LOG_ID(\"cloudaudit.googleapis.com/system_event\") OR LOG_ID(\"externalaudit.googleapis.com/system_event\") OR LOG_ID(\"cloudaudit.googleapis.com/access_transparency\") OR LOG_ID(\"externalaudit.googleapis.com/access_transparency\") OR LOG_ID(\"dns.googleapis.com/dns_queries\") OR (LOG_ID(\"compute.googleapis.com/nat_flows\") AND resource.type=\"nat_gateway\") OR (LOG_ID(\"compute.googleapis.com/firewall\") AND resource.type=\"gce_subnetwork\") OR (LOG_ID(\"compute.googleapis.com/vpc_flows\") AND resource.type=\"gce_subnetwork\") OR ((LOG_ID(\"ids.googleapis.com/threat\") OR LOG_ID(\"ids.googleapis.com/traffic\")) AND resource.type=\"ids.googleapis.com/Endpoint\") OR (LOG_ID(\"requests\") AND resource.type=\"http_load_balancer\")"
  isolator_data_access_logs_sink_filter = "LOG_ID(\"cloudaudit.googleapis.com/data_access\")"
}
