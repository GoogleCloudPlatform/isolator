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
  Org Policies - Custom - GKE
 *****************************************/
# The below were based off of CIS Benchmark
# https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks

/******************************************
  CIS Benchmark 6.2.1 - Restrict Default SA
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRestrictDefaultServiceAccount" {
  name         = "custom.gkeRestrictDefaultSa"
  parent       = "organizations/${var.organization_id}"
  display_name = "Restrict the use of default SA"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.2.1 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.config.serviceAccount == \"default\""
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/NodePool",
  ]
}
resource "google_org_policy_policy" "gkeRestrictDefaultServiceAccount" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRestrictDefaultServiceAccount.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.2.2 - Require Workload Identity
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireWorkloadIdentity" {
  name         = "custom.gkeRequireWorkloadIdentity"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require the use of Workload Identity"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.2.2 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.workloadIdentityConfig.workloadPool == \"\""
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRequireWorkloadIdentity" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireWorkloadIdentity.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.4.1 - Disable Metadata API
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeDisableMetadataApi" {
  name         = "custom.gkeDisableMetadataApi"
  parent       = "organizations/${var.organization_id}"
  display_name = "Disable GKE metadata API"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.4.1 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.config.metadata[\"disable-legacy-endpoints\"] != \"true\""
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/NodePool",
  ]
}
resource "google_org_policy_policy" "gkeDisableMetadataApi" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeDisableMetadataApi.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.4.2 - Disable Metadata API
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireMetadataServer" {
  name         = "custom.gkeRequireMetadataServer"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Metadata Server"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.4.2 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.config.workloadMetadataConfig.mode != \"GKE_METADATA\""
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/NodePool",
  ]
}
resource "google_org_policy_policy" "gkeRequireMetadataServer" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireMetadataServer.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.5.1 - Disable Metadata API
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireCos" {
  name         = "custom.gkeRequireCos"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Container Optimized OS"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.5.1 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.config.imageType != \"COS_CONTAINERD\""
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/NodePool",
  ]
}
resource "google_org_policy_policy" "gkeRequireCos" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireCos.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.5.2 - Require Auto Repair
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireAutoRepair" {
  name         = "custom.gkeRequireAutoRepair"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Auto Repair"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.5.2 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.management.autoRepair == false"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/NodePool",
  ]
}
resource "google_org_policy_policy" "gkeRequireAutoRepair" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireAutoRepair.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.5.3 - Require Auto Upgrade
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireAutoUpgrade" {
  name         = "custom.gkeRequireAutoUpgrade"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Auto Upgrade"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.5.3 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.management.autoUpgrade == false"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/NodePool",
  ]
}
resource "google_org_policy_policy" "gkeRequireAutoUpgrade" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireAutoUpgrade.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.5.4 - Restrict use of Regular Release Channel
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRestrictRegularReleaseChannel" {
  name         = "custom.gkeRestrictRegularReleaseChannel"
  parent       = "organizations/${var.organization_id}"
  display_name = "Restrict use of Regular Release Channel"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.5.4 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.releaseChannel.channel != \"REGULAR\""
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRestrictRegularReleaseChannel" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRestrictRegularReleaseChannel.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.5.5 - Require Shielded Nodes
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireShieldedNodes" {
  name         = "custom.gkeRequireShieldedNodes"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Shielded Nodes"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.5.5 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.shieldedNodes.enabled == false"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRequireShieldedNodes" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireShieldedNodes.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.5.6 - Require Integrity Monitoring
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireIntegrityMonitoring" {
  name         = "custom.gkeRequireIntegrityMonitoring"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Integrity Monitoring"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.5.6 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.config.shieldedInstanceConfig.enableIntegrityMonitoring == false"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/NodePool",
  ]
}
resource "google_org_policy_policy" "gkeRequireIntegrityMonitoring" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireIntegrityMonitoring.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.5.7 - Require Secure Boot
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireSecureBoot" {
  name         = "custom.gkeRequireSecureBoot"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Secure Boot"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.5.7 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.config.shieldedInstanceConfig.enableSecureBoot == false"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/NodePool",
  ]
}
resource "google_org_policy_policy" "gkeRequireSecureBoot" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireSecureBoot.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.6.2 - Require Cluster Native VPC
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireClusterNativeVpc" {
  name         = "custom.gkeRequireClusterNativeVpc"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Cluster Native VPC"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.6.2 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.ipAllocationPolicy.useIpAliases == false"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRequireClusterNativeVpc" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireClusterNativeVpc.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.6.3 - Require Master Auth Networks
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireMasterAuthNetworks" {
  name         = "custom.gkeRequireMasterAuthNetworks"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Master Auth Networks"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.6.3 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.masterAuthorizedNetworksConfig.enabled == false"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRequireMasterAuthNetworks" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireMasterAuthNetworks.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.6.4 - Restrict Public Endpoint Access
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRestrictPublicEndpointAccess" {
  name         = "custom.gkeRestrictPublicEndpointAccess"
  parent       = "organizations/${var.organization_id}"
  display_name = "Restrict Public Endpoint Access"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.6.4 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.privateClusterConfig.enablePrivateEndpoint == false"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRestrictPublicEndpointAccess" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRestrictPublicEndpointAccess.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.6.5 - Require Private Nodes
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequirePrivateNodes" {
  name         = "custom.gkeRequirePrivateNodes"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Private Nodes"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.6.5 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.privateClusterConfig.enablePrivateNodes == false"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRequirePrivateNodes" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequirePrivateNodes.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.7.1 - Require Logging & Monitoring
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireLoggingMonitoring" {
  name         = "custom.gkeRequireLoggingMonitoring"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Logging and Monitoring"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.7.1 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.loggingService != 'logging.googleapis.com/kubernetes' || resource.monitoringService != 'monitoring.googleapis.com/kubernetes'"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRequireLoggingMonitoring" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireLoggingMonitoring.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.8.2 - Restrict Client Certification Authentication
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRestrictClientCertAuth" {
  name         = "custom.gkeRestrictClientCertAuth"
  parent       = "organizations/${var.organization_id}"
  display_name = "Restrict Client Certification Authentication"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.8.2 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.masterAuth.clientCertificateConfig.issueClientCertificate == true"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRestrictClientCertAuth" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRestrictClientCertAuth.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.8.3 - Require Google Group RBAC
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRequireGoogleGroupsRbac" {
  name         = "custom.gkeRequireGoogleGroupsRbac"
  parent       = "organizations/${var.organization_id}"
  display_name = "Require Google Group RBAC"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.8.3 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.authenticatorGroupsConfig.enabled == false"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRequireGoogleGroupsRbac" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRequireGoogleGroupsRbac.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.8.4 - Restrict Legacy ABAC
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRestrictLegacyAbac" {
  name         = "custom.gkeRestrictLegacyAbac"
  parent       = "organizations/${var.organization_id}"
  display_name = "Restrict Legacy ABAC"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.8.4 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.legacyAbac.enabled == true"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRestrictLegacyAbac" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRestrictLegacyAbac.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

/******************************************
  CIS Benchmark 6.10.2 - Restrict Alpha Clusters
 *****************************************/
resource "google_org_policy_custom_constraint" "gkeRestrictAlphaClusters" {
  name         = "custom.gkeRestrictAlphaClusters"
  parent       = "organizations/${var.organization_id}"
  display_name = "Restrict Alpha Clusters"
  description  = "Custom Org Policy for GKE - CIS Benchmark - 6.10.2 - https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks"
  action_type  = "DENY"
  condition    = "resource.enableKubernetesAlpha == true"
  method_types = [
    "CREATE",
    "UPDATE"
  ]
  resource_types = [
    "container.googleapis.com/Cluster",
  ]
}
resource "google_org_policy_policy" "gkeRestrictAlphaClusters" {
  name   = "folders/${var.folder_id}/policies/${google_org_policy_custom_constraint.gkeRestrictAlphaClusters.name}"
  parent = "folders/${var.folder_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}