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
  Inputs
 *****************************************/
#TODO - Update inputs
# Service Accounts
sa_01_resource_hierarchy         = ""
sa_02_org_policies               = ""
sa_03_vpc_sc                     = ""
sa_04_security_projects          = ""
sa_05_security_project_resources = ""
sa_06_data_projects              = ""
sa_07_data_projects_resources    = ""

#TODO Uncomment after creating the org-level log sink.
# Note this follows the pattern “service-org-{org ID}@gcp-sa-logging.iam.gserviceaccount.com”
# isolator_log_bucket_log_sink_org_node_writer = ""

# Groups
grp_isolator_partner_security_team = ""

approved_security_users = [
  "", # Users need to be in the format user:jdoe@example.com
]

approved_data_users = [
  "", # Users need to be in the format user:jdoe@example.com
]

# VPC-SC Related
access_policy_name              = "" # This is the numeric name of your access policy.
required_minimum_chrome_version = ""