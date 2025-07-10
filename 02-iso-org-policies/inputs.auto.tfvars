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
isolator_folder_id  = ""
organization_id     = ""

// Domain Identities
// You can run: gcloud organizations list
// In the results you'll see "DIRECTORY_CUSTOMER_ID", use that value for the domains you want to permit in IAM
domain_identities = [
  "", # Most organizations should, by default only use one domain
]

// Domain Contacts
// Enter the email domain(s) of users in this environment.
// ie. "@google.com"
domain_contacts = [
  "",
]

service_account_expiry = [
  "720h",
]

# In general this list should not change
custom_constraints_to_apply = [
  # Restrict Cloud Build Pools to be Private
  "restrictCloudBuildPublicEgress",
  # CIS Benchmark 6.4.1 - Disable Metadata API
  "gkeDisableMetadataApi",
  # CIS Benchmark 6.4.2 - Require GKE Metadata Server
  "gkeRequireMetadataServer",
  # CIS Benchmark 6.5.1 - Require Container Optimized OS
  "gkeRequireCos",
  # CIS Benchmark 6.5.2 - Require Auto Repair
  "gkeRequireAutoRepair",
  # CIS Benchmark 6.5.3 - Require Auto Upgrade
  "gkeRequireAutoUpgrade",
  # CIS Benchmark 6.5.4 - Restrict use of Regular Release Channel
  "gkeRestrictRegularReleaseChannel",
  # CIS Benchmark 6.5.5 - Require Shielded Nodes
  "gkeRequireShieldedNodes",
  # CIS Benchmark 6.5.6 - Require Integrity Monitoring
  "gkeRequireIntegrityMonitoring",
  # CIS Benchmark 6.5.7 - Require Secure Boot
  "gkeRequireSecureBoot",
  # CIS Benchmark 6.6.2 - Require Cluster Native VPC
  "gkeRequireClusterNativeVpc",
  # CIS Benchmark 6.6.3 - Require Master Authorized Networks
  "gkeRequireMasterAuthNetworks",
  # CIS Benchmark 6.7.1 - Require Logging & Monitoring
  "gkeRequireLoggingMonitoring",
  # CIS Benchmark 6.8.2 - Restrict Client Certificate Authentication
  "gkeRestrictClientCertAuth",
  # CIS Benchmark 6.8.4 - Restrict Legacy ABAC
  "gkeRestrictLegacyAbac",
  # CIS Benchmark 6.10.2 - Restrict Alpha Clusters
  "gkeRestrictAlphaClusters",
]