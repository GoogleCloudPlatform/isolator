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
  Constraints not enforced (Set to Google default)
*****************************************/

/******************************************
  The module below turns off inheritance of Org Policy settings
  The module also makes sure to set the Org Policy to it's original Google default
  setting. Without this block these policies could be configured higher in the
  Org Hierarchy in Google Cloud and thus inherit into the Isolator environment.
  As they are not expected it could break deployments in unexpected ways.
  Organizations should review these to determine if enforcement/configuration of
  them is preferred for their specific Isolator deployment.
  For a full list of org policy constraints please see the link below:
  https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints
*****************************************/

module "folder_org_policies_set_to_default" {
  source          = "./modules/org-policy-default"
  folder_id       = var.isolator_folder_id
  constraint_list = [
    # Multi Service
    "serviceuser.services",
    "gcp.restrictServiceUsage",
    "gcp.restrictCmekCryptoKeyProjects",
    "gcp.restrictNonCmekServices",
    # Anthos
    "meshconfig.allowedVpcscModes",
    # Cloud Deploy
    "clouddeploy.disableServiceLabelGeneration",
    # Cloud KMS
    "cloudkms.allowedProtectionLevels",
    # Cloud Run
    "run.allowedBinaryAuthorizationPolicies",
    # Healthcare
    "gcp.disableCloudLogging",
    # Cloud Marketplace
    "commerceorggovernance.disablePublicMarketplace",
    # Cloud Scheduler
    "cloudscheduler.allowedTargetTypes",
    # Cloud SQL
    "sql.restrictNoncompliantDiagnosticDataAccess",
    "sql.restrictNoncompliantResourceCreation",
    # Cloud Storage (GCS)
    "storage.retentionPolicySeconds",
    # Compute Engine (GCE)
    "compute.allowedVlanAttachmentEncryption",
    "compute.disableGlobalCloudArmorPolicy",
    "compute.disableGlobalLoadBalancing",
    "compute.disableInstanceDataAccessApis",
    "compute.disableNonFIPSMachineTypes",
    "compute.enableComplianceMemoryProtection",
    "compute.disablePrivateServiceConnectCreationForConsumers",
    "compute.restrictSharedVpcBackendServices",
    "compute.restrictSharedVpcSubnetworks",
    "compute.setNewProjectDefaultToZonalDNSOnly",
    "compute.sharedReservationsOwnerProjects",
    "compute.storageResourceUseRestrictions",
    "compute.trustedImageProjects",
    "compute.vmCanIpForward",
    "compute.disableSshInBrowser",
    # Essential Contacts
    "essentialcontacts.allowedContactDomains",
    # Google Cloud Marketplace
    "commerceorggovernance.marketplaceServices",
    # Google Kubernetes Engine (GKE)
    "container.restrictNoncompliantDiagnosticDataAccess",
    # IAM
    "iam.allowServiceAccountCredentialLifetimeExtension",
    "iam.disableServiceAccountCreation",
    "iam.disableWorkloadIdentityClusterCreation",
    # IAP
    "iap.requireGlobalIapWebDisabled",
    "iap.requireRegionalIapWebDisabled",
    # Resource Manager
    "iam.restrictCrossProjectServiceAccountLienRemoval",
    "compute.restrictXpnProjectLienRemoval",
    "resourcemanager.allowEnabledServicesForExport",
    "resourcemanager.allowedExportDestinations",
    "resourcemanager.allowedImportSources",
  ]
}

/******************************************
  Enforced Boolean Constraints
 *****************************************/

/******************************************
 The module below sets all the Org Policy constraints to "true" (thus only bool org polices are referenced)
 In order to help team members understand the below constraints, a short
 description is included. Please note, these descriptions are to provide additional
 context and insight behind the Isolator team's rationale. They are not meant
 to be authoritative for all organizations to use nor exhaustive as to the
 reasons to use a policy.

 Going back to the principles of Isolator, the goal of policies is focused
 on the reduction of data exfiltration risk.

 The formatting is to have the reason stated above each constraint for example:

 # Blocks the ability to make a bucket public. Public access to a bucket risks
 # anyone on the internet accessing the data. Note, VPC SC still provides
 # defense in depth.
 "storage.publicAccessPrevention",

 While this may be obvious (public bucket = bad) as we move towards all
 constraints, what may be obvious to one users may not be obvious to another.
 Thus we encourage explicitly stating the rationale for each. We also encourage
 calling out when constraints work together or with other controls (like the
 example mentions that VPC SC still protects the bucket)
*****************************************/

module "folder_org_policies_boolean_enforced" {
  source           = "./modules/org-policy-bool"
  folder_id        = var.isolator_folder_id
  constraint_value = "TRUE"

  constraint_list = [
    # App Engine
    # Disabling download of source code. Source code is sensitive information
    # which access to download should be limited as it can pose a risk to an
    # organization if it is accessed by a bad actor.
    "appengine.disableCodeDownload",

    # BigQuery
    # Reducing attack surface by disabling features/capabilities not intended
    # for use in the environment helps reduce risk. Integration/connection
    # with external services is not in scope nor intended with Isolator.
    "bigquery.disableBQOmniAWS",
    "bigquery.disableBQOmniAzure",

    # Cloud Functions
    # Without a VPCConnector Functions may egress to the internet
    # Unrestricted internet access provides a data exfiltration path
    # Required to comply with VPC Service Controls
    # Note, this control only requires a connector and will be used with the
    # other listed constraint which forces all traffic to route through the
    # connector.
    # https://cloud.google.com/functions/docs/securing/using-vpc-service-controls
    # Cloud Functions 1st Generation is impacted by this, and we do restrict to 2ndGen
    # This provides defence in depth if a team does attempt to use (via exception)
    # Gen1
    "cloudfunctions.requireVPCConnector",

    # Cloud SQL
    # Isolator does not expect non-RFC1918 access to SQL, thus creating an
    # authorized network is considered as risk as it follows an anti-pattern
    # https://cloud.google.com/sql/docs/mysql/org-policy/org-policy#connection_organization_policies
    "sql.restrictAuthorizedNetworks",

    # Allowing access to Cloud SQL from a public IP creates a data exfiltration
    # Blocking public access via the constraint requires connections to come
    # from internal IPs
    "sql.restrictPublicIp",

    # Compute Engine (GCE)
    # Self managed certificates can pose a risk to the organization
    # Google-managed certificates are the recommended method
    # https://cloud.google.com/certificate-manager/docs/certificates
    # Note, this constraint does not impact regional self managed
    "compute.disableGlobalSelfManagedSslCertificate",

    # Reducing attack service helps keep the environment more secure
    # By default serial port access and logging should be disabled
    # If necessary, in troubleshooting scenarios, teams may apply exceptions
    # but the default should be to lock down
    "compute.disableGlobalSerialPortAccess",
    "compute.disableSerialPortAccess",
    "compute.disableSerialPortLogging",

    # Blocks the ability to write to metadata from within GCE VM
    # Writing to metadata from VM may be used as an exfiltration path to move
    # data from a VM to the compute API (where if not appropriate data should not
    # be stored)
    "compute.disableGuestAttributesAccess",

    # Reducing attack surface and blocking internet access to resources in
    # Isolator helps reduce the risk of data exfiltration via these public paths
    "compute.disableInternetNetworkEndpointGroup",

    # Nested virtualization is not an expected pattern and introduces risk
    # to the environment through additional attack surface
    "compute.disableNestedVirtualization",

    # Reducing attack surface and blocking internet access to resources in
    # Isolator helps reduce the risk of data exfiltration via these public paths
    "compute.disableVpcExternalIpv6",

    # Force use of OS Login
    # https://cloud.google.com/compute/docs/oslogin
    # OS Login ties access to a VM in Isolator to a specific identity
    # Without this constraint one risk introduced is privilege escalation as
    # an SSH key could be added that is associated with a user which does not have
    # permission to use the Service Account assigned to a VM. Once the user connects
    # they will be able to act-as that Service Account.
    "compute.requireOsLogin",

    # Forcing the use of Shielded VMs which "verifiable integrity of your
    # Compute Engine VM instances"
    # https://cloud.google.com/compute/shielded-vm/docs/shielded-vm
    # Note, at times a GCP service that uses GCE VMs may not support
    # shielded VMs. In those cases an organization must review the risk and
    # determine if an exception to this constraint is acceptable. By default,
    # Isolator does not allow use of VMs which do not support this capability.
    "compute.requireShieldedVm",

    # Default network creation occurs when the GCE API is enabled in a project
    # The default network creates subnets in all regions and deploys firewall
    # rules which allows SSH&RDP from anywhere. These regions and rules introduce
    # unnecessary risk. All Isolator networks should be custom which include the
    # approved regions and only create firewall rules necessary for the VPC to
    # function properly
    # https://cloud.google.com/vpc/docs/vpc#default-network
    "compute.skipDefaultNetworkCreation",


    # Reduce attack surface. Isolator does not, by default, use IPv6. Thus,
    # use of IPv6 is restricted to reduce attack surface.
    "compute.disableAllIpv6",
    "compute.disableVpcInternalIpv6",
    "compute.disableHybridCloudIpv6",

    # Datastream
    # Reducing attack surface and blocking internet access to resources in
    # Isolator helps reduce the risk of data exfiltration via these public paths
    "datastream.disablePublicConnectivity",


    # Firestore
    # Restrict using AppEngine SAfor import/export which can be abused by a bad
    # actor, and limits to Firestore agent. This is the future default so for
    # most cases an unnecessary constraint
    "firestore.requireP4SAforImportExport",

    # IAM
    # Isolator enables audit logging (data audit logs) to capture access to the
    # sensitive data contained in Isolator. This constraint disables the ability
    # to add an identity to exemption. This reduces risk as if an identity were
    # added it's access logs would not be surfaced and thus reduce visibility to
    # access for that identity.
    "iam.disableAuditLoggingExemption",

    # Service Account keys pose significant risk to organizations if they are not
    # properly protected and rotated. In addition, for Isolator, no compute is
    # set to run outside of Google Cloud. Thus Service Accounts would only
    # be used with Google services (GCE, GKE, RunFunctions). In those cases
    # no keys need to be (and therefore should not be) created.
    # https://cloud.google.com/docs/authentication
    # Disabling key upload/download(creation) blocks users from creating this
    # unnecessary risk.
    "iam.disableServiceAccountKeyCreation",
    "iam.disableServiceAccountKeyUpload",

    # Service Consumer Management
    "iam.automaticIamGrantsForDefaultServiceAccounts",

    # Storage (GCS)
    # While public access prevention helps reduce risk of public access it does
    # not limit use of ACLs. ACLs allow the assignment of identities which may
    # not be in the desired organization (e.g. a gmail account). This
    # constraint forces use of IAM at the bucket level and thus works with Domain
    # Restricted Sharing to only allow identities from the desired org(s).
    "storage.uniformBucketLevelAccess",

    # Enforcing this constraint provides additional audit log information for
    # GCS. When protecting sensitive information (intent of Isolator) additional
    # log information helps provide greater insights.
    # Note, this increases the amount of logs gathered and thus can increase
    # costs of running/maintaining Isolator.
    # https://cloud.google.com/storage/docs/org-policy-constraints#audit-logging
    "gcp.detailedAuditLoggingMode",

    # Blocks the ability to make a bucket public. Public access to a bucket risks
    # anyone on the internet accessing the data. Note, VPC SC still provides
    # defense in depth.
    "storage.publicAccessPrevention",


    # Vertex AI Workbench
    # Downloading files off of a Vertex Workbench poses a risk to allow users
    # to exfil data. One pattern used at times is to require users to load files
    # to GCS first so history of the file can be preserved and viewed (potentially
    # even running scans against the files)
    "ainotebooks.disableFileDownloads",

    # Root access to a Workbench provides risks as root access allows users
    # to potentially make changes to the VM that are unwanted/undesired.
    # Following the principle of least privilege users should not need root
    # access
    "ainotebooks.disableRootAccess",

    #
    "ainotebooks.disableTerminal",

    # Workbench vms that are not upgraded can pose a security risk due to
    # security vulnerabilities which are known but unpatched. Requiring an
    # upgrade schedule helps address this risk.
    "ainotebooks.requireAutoUpgradeSchedule",

  ]
}

/******************************************
  List Constraints Enforced
 *****************************************/


# Cloud Build
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

# Multi Service
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

# Identity and Access Management
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

# Cloud Build
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

# Cloud Storage
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

# Compute Engine
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

# Compute Engine
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

# Compute Engine
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


# Compute Engine
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

# Compute Engine
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

# Cloud Functions
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

# Cloud Functions
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

# Cloud Functions
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

# Cloud Run
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

# Cloud Run
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

# Compute Engine
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

# Compute Engine
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

# Compute Engine
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

# Compute Engine
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

# Identity & Access Management
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

# Identity & Access Management
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

# Service Control
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

# Vertex AI Workbench
# Each notebook should be dedicated to a single user. A shared service account
# used by multiple users does not follow the principle of least privlege and
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