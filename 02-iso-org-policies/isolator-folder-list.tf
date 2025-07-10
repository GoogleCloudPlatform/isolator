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
  List Constraints Enforced
 *****************************************/
####################################################################
# Multi Service
####################################################################
# Reduce attack surface.By limiting GCP resources to approved regions/locations
# overall attack surface may be limited.
# Note, this is a variable as the posture is not that specific regions are somehow
# more secure, but rather the ability to reduce to specific regions ensures teams
# deploy only to approved and desired regions.
resource "google_org_policy_policy" "isolator_folder_enforce_resource_locations" {
  name   = "folders/${var.isolator_folder_id}/policies/gcp.resourceLocations"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = var.allowed_locations
      }
    }
  }
}

# Restricting older versions of TLS in favor of newer. Older versions use
# older/weaker ciphers
resource "google_org_policy_policy" "isolator_folder_serv_control_restrict_tls_version" {
  name   = "folders/${var.isolator_folder_id}/policies/gcp.restrictTLSVersion"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        denied_values = [
          "TLS_VERSION_1",
          "TLS_VERSION_1_1",
        ]
      }
    }
  }
}

####################################################################
# Identity and Access Management
####################################################################
# Identity and Access Management
# This constraint helps by only allowing identities from approved domains to be
# added to GCP IAM. Without this, identities from other orgs and consumer (e.g. gmail)
# may be assigned permissions in IAM. Note, VPC SC still protects APIs and identities
# still need to meet any VPC SC conditions for Isolator.
# https://cloud.google.com/resource-manager/docs/organization-policy/restricting-domains
resource "google_org_policy_policy" "isolator_folder_domain_restricted_sharing" {
  name   = "folders/${var.isolator_folder_id}/policies/iam.allowedPolicyMemberDomains"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = var.domain_identities
      }
    }
  }
}

# While SA key upload/download is restricted by default and thus this policy
# should not have a large impact, this policy helps force key expiry. Without this
# any keys created (e.g. AN exception is sought for a unique reason) are
# perpetual
resource "google_org_policy_policy" "isolator_folder_service_account_key_expiry" {
  name   = "folders/${var.isolator_folder_id}/policies/iam.serviceAccountKeyExpiryHours"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = var.service_account_expiry
      }
    }
  }
}

# Reduce attack surface and follow isolation. WIF connectivity is a powerful and
# useful tool to protect access to Google Cloud (and remove key use). Isolator
# does not connect and by default does not allow connectivity to it from external
# sites.
# If, for long term use of Isolator a team reviews and determines connectivity
# is required, WIF is a preferred path (versus other org policy exceptions needed
# such as creating service account keys)
resource "google_org_policy_policy" "isolator_folder_iam_wif_aws_restriction" {
  name   = "folders/${var.isolator_folder_id}/policies/iam.workloadIdentityPoolAwsAccounts"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      deny_all = "TRUE"
    }
  }
}

# Reduce attack surface and follow isolation. WIF connectivity is a powerful and
# useful tool to protect access to Google Cloud (and remove key use). Isolator
# does not connect and by default does not allow connectivity to it from external
# sites.
# If, for long term use of Isolator a team reviews and determines connectivity
# is required, WIF is a preferred path (versus other org policy exceptions needed
# such as creating service account keys)
resource "google_org_policy_policy" "isolator_folder_iam_wif_pool_providers_restriction" {
  name   = "folders/${var.isolator_folder_id}/policies/iam.workloadIdentityPoolProviders"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "https://confidentialcomputing.googleapis.com",
          "https://sts.googleapis.com",
        ]
      }
    }
  }
}

####################################################################
# Cloud Build
####################################################################
# Disable integrations to external services which reduces the attack surface
resource "google_org_policy_policy" "isolator_folder_restrict_cloud_build_integrations" {
  name   = "folders/${var.isolator_folder_id}/policies/cloudbuild.allowedIntegrations"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      deny_all = "TRUE"
    }
  }
}

# Reducing attack surface and data exfiltration paths. By restricting worker pools
# for Cloud Build to the Isolator folder (i.e. cannot use pools from other parts
# of an organizations GCP environment)
resource "google_org_policy_policy" "isolator_folder_cloud_build_allowed_worker_pools" {
  name   = "folders/${var.isolator_folder_id}/policies/cloudbuild.allowedWorkerPools"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      deny_all = "TRUE"
    }
  }
}

####################################################################
# Cloud Storage
####################################################################
# Reduce attack surface. Restrict alternate authN types (i.e. restrict HMAC)
resource "google_org_policy_policy" "isolator_folder_gcs_restrictauthtypes" {
  name   = "folders/${var.isolator_folder_id}/policies/storage.restrictAuthTypes"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        denied_values = [
          "in:ALL_HMAC_SIGNED_REQUESTS",
        ]
      }
    }
  }
}

####################################################################
# Compute Engine
####################################################################
# Reducing attack surface and blocking internet access to resources in
# Isolator helps reduce the risk of data exfiltration via these public paths
# https://cloud.google.com/load-balancing/docs/forwarding-rule-concepts
resource "google_org_policy_policy" "isolator_folder_gce_restrict_proto_forward_type" {
  name   = "folders/${var.isolator_folder_id}/policies/compute.restrictProtocolForwardingCreationForTypes"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "INTERNAL",
        ]
      }
    }
  }
}

# VPC Flow Logs help provide some insights into traffic within VPCs. Enabling
# flow logs helps ensure Isolator collects this information.
# https://cloud.google.com/vpc/docs/org-policy-flow-logs#sampling-rates
resource "google_org_policy_policy" "isolator_folder_gce_require_vpc_flow_logs" {
  name   = "folders/${var.isolator_folder_id}/policies/compute.requireVpcFlowLogs"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "COMPREHENSIVE",
        ]
      }
    }
  }
}

# Confidential VMs are "hardware-based memory encryption to help ensure
# your data and applications can't be read or modified while in use"
# https://cloud.google.com/confidential-computing/confidential-vm/docs/confidential-vm-overview
# Note, while this constraint will be enforced by default in Isolator
# situations may arise where a service does not support confidential VMs. In these
# situations an organization should review the need and risk and determine if
# granting an exception is appropriate
resource "google_org_policy_policy" "isolator_folder_gce_restrict_confidential_compute" {
  name   = "folders/${var.isolator_folder_id}/policies/compute.restrictNonConfidentialComputing"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        denied_values = [
          "compute.googleapis.com",
          "container.googleapis.com"
        ]
      }
    }
  }
}

# Reduce attach surface and adhere to Isolator principle of isolation.
# Interconnects (Partner & Dedicated) would introduce network connectivity to
# resources in Isolator, thus introducing data exfiltration paths.
resource "google_org_policy_policy" "isolator_folder_gce_restrict_partner_interconnect" {
  name   = "folders/${var.isolator_folder_id}/policies/compute.restrictPartnerInterconnectUsage"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      deny_all = "TRUE"
    }
  }
}

# Reduce attach surface and adhere to Isolator principle of isolation.
# Interconnects (Partner & Dedicated) would introduce network connectivity to
# resources in Isolator, thus introducing data exfiltration paths.
resource "google_org_policy_policy" "isolator_folder_gce_restrict_dedicated_interconnect" {
  name   = "folders/${var.isolator_folder_id}/policies/compute.restrictDedicatedInterconnectUsage"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      deny_all = "TRUE"
    }
  }
}

# Reducing attack surface and blocking internet access to resources in
# Isolator helps reduce the risk of data exfiltration via these public paths
resource "google_org_policy_policy" "isolator_folder_compute_restrict_load_balancer_type" {
  name   = "folders/${var.isolator_folder_id}/policies/compute.restrictLoadBalancerCreationForTypes"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "INTERNAL_TCP_UDP",
          "INTERNAL_HTTP_HTTPS",
          "REGIONAL_INTERNAL_MANAGED_TCP_PROXY",
        ]
      }
    }
  }
}

# Reducing attack surface and blocking internet access to resources in
# Isolator helps reduce the risk of data exfiltration via these public paths
resource "google_org_policy_policy" "isolator_folder_compute_external_ip_restrict" {
  name   = "folders/${var.isolator_folder_id}/policies/compute.vmExternalIpAccess"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      deny_all = "TRUE"
    }
  }
}

# Reduce attach surface and adhere to Isolator principle of isolation.
# VPNs would introduce network connectivity to resources in Isolator,
# thus introducing data exfiltration paths.
resource "google_org_policy_policy" "isolator_folder_compute_restrict_vpn" {
  name   = "folders/${var.isolator_folder_id}/policies/compute.restrictVpnPeerIPs"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      deny_all = "TRUE"
    }
  }
}

# Reducing attack surface and blocking internet access to resources in
# Isolator helps reduce the risk of data exfiltration via these public paths
resource "google_org_policy_policy" "isolator_folder_compute_restrict_nat" {
  name   = "folders/${var.isolator_folder_id}/policies/compute.restrictCloudNATUsage"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      deny_all = "TRUE"
    }
  }
}




####################################################################
# Cloud Functions
####################################################################
# Reducing attack surface and blocking internet access to resources in
# Isolator helps reduce the risk of data exfiltration via these public paths
resource "google_org_policy_policy" "isolator_folder_cloud_functions_allowed_ingress" {
  name   = "folders/${var.isolator_folder_id}/policies/cloudfunctions.allowedIngressSettings"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "ALLOW_INTERNAL_ONLY",
        ]
      }
    }
  }
}

# While the constraint for VPC Connector forces a connector for functions
# it alone does not require all traffic must route through the connector.
# This constraint forces all traffic (internal and external bound)to route
# through the VPC connector. As our VPCs are restricted from egressing to the
# internet, any internet bound traffic routes to our VPC and is blocked.
# Required for VPC Service Controls
# https://cloud.google.com/functions/docs/securing/using-vpc-service-controls
# Cloud Functions 1st Generation is impacted by this, and we do restrict to 2ndGen
# This provides defence in depth if a team does attempt to use (via exception)
# Gen1
resource "google_org_policy_policy" "isolator_folder_cloud_functions_vpc_connector_egress" {
  name   = "folders/${var.isolator_folder_id}/policies/cloudfunctions.allowedVpcConnectorEgressSettings"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "ALL_TRAFFIC",
        ]
      }
    }
  }
}

resource "google_org_policy_policy" "isolator_folder_cloud_functions_allowed_gen" {
  name   = "folders/${var.isolator_folder_id}/policies/cloudfunctions.restrictAllowedGenerations"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "2ndGen",
        ]
      }
    }
  }
}

####################################################################
# Cloud Run
####################################################################
# Reducing attack surface and blocking internet access to resources in
# Isolator helps reduce the risk of data exfiltration via these public paths
# https://cloud.google.com/run/docs/securing/ingress
resource "google_org_policy_policy" "isolator_folder_cloud_run_allowed_ingress" {
  name   = "folders/${var.isolator_folder_id}/policies/run.allowedIngress"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "internal",
        ]
      }
    }
  }
}

# This requires all traffic egressing from cloud run to egress towards a VPC
# in Isolator (versus egressing to the internet which introduces data exfil risk)
# Required for VPC Service Controls
# https://cloud.google.com/run/docs/securing/using-vpc-service-controls#org-policy-behavior
resource "google_org_policy_policy" "isolator_folder_cloud_run_allowed_vpc_egress" {
  name   = "folders/${var.isolator_folder_id}/policies/run.allowedVPCEgress"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "all-traffic",
        ]
      }
    }
  }
}

####################################################################
# Dataform
####################################################################

resource "google_org_policy_policy" "isolator_folder_dataform_restrict_git_remotes" {
  name   = "folders/${var.isolator_folder_id}/policies/dataform.restrictGitRemotes"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
        deny_all = "TRUE"
    }
  }
}


####################################################################
# Vertex AI Workbench
####################################################################
# Each notebook should be dedicated to a single user. A shared service account
# used by multiple users does not follow the principle of least privilege and
# can make it hard to attribute actions
resource "google_org_policy_policy" "isolator_folder_vertex_workbench_access_mode" {
  name   = "folders/${var.isolator_folder_id}/policies/ainotebooks.accessMode"
  parent = "folders/${var.isolator_folder_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "single-user",
        ]
      }
    }
  }
}