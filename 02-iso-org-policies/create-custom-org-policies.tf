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

#TODO - READ WARNING message below
/******************************************
  WARNING - It is HIGHLY RECOMMENDED that the policies defined here
  are applied by the central security team that manages Org Policies
  for the entire organization. This can be managed centrally and it will
  also make it easier for other teams to reference the full list of
  custom org policies. It also reduces the risk of issues/errors of different
  pipelines creating duplicate policies and causes errors.
 *****************************************/

/******************************************
  Cloud Build Custom Org Policies
 *****************************************/
module "custom_org_policy_restrictCloudBuildPublicEgress" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "restrictCloudBuildPublicEgress"
  display_name     = "Restrict the use of public Egress for Cloud Build Worker Pools"
  description      = "Cloud Build worker pools can be configured to have public egress. This policy restricts Cloud Build Worker Pools from deploying with public egress."
  condition        = "resource.privatePoolV1Config.networkConfig.egressOption == \"NO_PUBLIC_EGRESS\""
  resource_types   = ["cloudbuild.googleapis.com/WorkerPool"]
  action_type      = "ALLOW" # Default is "DENY" but want allow to be simple
}

/******************************************
  GKE Custom Org Policies
 *****************************************/
/******************************************
  CIS Benchmark 6.4.1 - Disable Metadata API
 *****************************************/
module "custom_org_policy_gkeDisableMetadataApi" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeDisableMetadataApi"
  display_name     = "Disable GKE metadata API"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.4.1 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.config.metadata[\"disable-legacy-endpoints\"] != \"true\""
  resource_types   = ["container.googleapis.com/NodePool"]
}

/******************************************
  CIS Benchmark 6.4.2 - Disable Metadata API
 *****************************************/
module "custom_org_policy_gkeRequireMetadataServer" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRequireMetadataServer"
  display_name     = "Require Metadata Server"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.4.2 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.config.workloadMetadataConfig.mode != \"GKE_METADATA\""
  resource_types   = ["container.googleapis.com/NodePool"]
}

/******************************************
  CIS Benchmark 6.5.1 - Disable Metadata API
 *****************************************/
module "custom_org_policy_gkeRequireCos" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRequireCos"
  display_name     = "Require Container Optimized OS"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.5.1 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.config.imageType != \"COS_CONTAINERD\""
  resource_types   = ["container.googleapis.com/NodePool"]
}

/******************************************
  CIS Benchmark 6.5.2 - Require Auto Repair
 *****************************************/
module "custom_org_policy_gkeRequireAutoRepair" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRequireAutoRepair"
  display_name     = "Require Auto Repair"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.5.2 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.management.autoRepair == false"
  resource_types   = ["container.googleapis.com/NodePool"]
}

/******************************************
  CIS Benchmark 6.5.3 - Require Auto Upgrade
 *****************************************/
module "custom_org_policy_gkeRequireAutoUpgrade" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRequireAutoUpgrade"
  display_name     = "Require Auto Upgrade"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.5.3 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.management.autoUpgrade == false"
  resource_types   = ["container.googleapis.com/NodePool"]
}

/******************************************
  CIS Benchmark 6.5.4 - Restrict use of Regular Release Channel
 *****************************************/
module "custom_org_policy_gkeRestrictRegularReleaseChannel" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRestrictRegularReleaseChannel"
  display_name     = "Restrict use of Regular Release Channel"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.5.4 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.releaseChannel.channel != \"REGULAR\""
  resource_types   = ["container.googleapis.com/Cluster"]
}

/******************************************
  CIS Benchmark 6.5.5 - Require Shielded Nodes
 *****************************************/
module "custom_org_policy_gkeRequireShieldedNodes" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRequireShieldedNodes"
  display_name     = "Require Shielded Nodes"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.5.5 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.shieldedNodes.enabled == false"
  resource_types   = ["container.googleapis.com/Cluster"]
}

/******************************************
  CIS Benchmark 6.5.6 - Require Integrity Monitoring
 *****************************************/
module "custom_org_policy_gkeRequireIntegrityMonitoring" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRequireIntegrityMonitoring"
  display_name     = "Require Integrity Monitoring"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.5.6 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.config.shieldedInstanceConfig.enableIntegrityMonitoring == false"
  resource_types   = ["container.googleapis.com/NodePool"]
}

/******************************************
  CIS Benchmark 6.5.7 - Require Secure Boot
 *****************************************/
module "custom_org_policy_gkeRequireSecureBoot" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRequireSecureBoot"
  display_name     = "Require Secure Boot"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.5.7 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.config.shieldedInstanceConfig.enableSecureBoot == false"
  resource_types   = ["container.googleapis.com/NodePool"]
}

/******************************************
  CIS Benchmark 6.6.2 - Require Cluster Native VPC
 *****************************************/
module "custom_org_policy_gkeRequireClusterNativeVpc" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRequireClusterNativeVpc"
  display_name     = "Require Cluster Native VPC"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.6.2 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.ipAllocationPolicy.useIpAliases == false"
  resource_types   = ["container.googleapis.com/Cluster"]
}

/******************************************
  CIS Benchmark 6.6.3 - Require Master Auth Networks
 *****************************************/
module "custom_org_policy_gkeRequireMasterAuthNetworks" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRequireMasterAuthNetworks"
  display_name     = "Require Master Auth Networks"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.6.3 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.masterAuthorizedNetworksConfig.enabled == false"
  resource_types   = ["container.googleapis.com/Cluster"]
}

/******************************************
  CIS Benchmark 6.7.1 - Require Logging & Monitoring
 *****************************************/
module "custom_org_policy_gkeRequireLoggingMonitoring" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRequireLoggingMonitoring"
  display_name     = "Require Logging and Monitoring"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.7.1 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.loggingService != 'logging.googleapis.com/kubernetes' || resource.monitoringService != 'monitoring.googleapis.com/kubernetes'"
  resource_types   = ["container.googleapis.com/Cluster"]
}

/******************************************
  CIS Benchmark 6.8.2 - Restrict Client Certification Authentication
 *****************************************/
module "custom_org_policy_gkeRestrictClientCertAuth" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRestrictClientCertAuth"
  display_name     = "Restrict Client Certification Authentication"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.8.2 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.masterAuth.clientCertificateConfig.issueClientCertificate == true"
  resource_types   = ["container.googleapis.com/Cluster"]
}

/******************************************
  CIS Benchmark 6.8.4 - Restrict Legacy ABAC
 *****************************************/
module "custom_org_policy_gkeRestrictLegacyAbac" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRestrictLegacyAbac"
  display_name     = "Restrict Legacy ABAC"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.8.4 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.legacyAbac.enabled == true"
  resource_types   = ["container.googleapis.com/Cluster"]
}

/******************************************
  CIS Benchmark 6.10.2 - Restrict Alpha Clusters
 *****************************************/
module "custom_org_policy_gkeRestrictAlphaClusters" {
  source = "./modules/custom-org-policy-create"
  organization_id = var.organization_id
  constraint_name  = "gkeRestrictAlphaClusters"
  display_name     = "Restrict Alpha Clusters"
  description      = "Custom Org Policy for GKE - CIS Benchmark - 6.10.2 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  condition        = "resource.enableKubernetesAlpha == true"
  resource_types   = ["container.googleapis.com/Cluster"]
}