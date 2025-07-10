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
  Enforced Custom Constraints
 *****************************************/
module "apply_custom_org_policies" {
  source = "./modules/custom-org-policy-apply"
  folder_id = var.isolator_folder_id
  constraints_to_apply = var.custom_constraints_to_apply
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
  constraint_list = [
    ####################################################################
    # App Engine
    ####################################################################
    # Disabling download of source code. Source code is sensitive information
    # which access to download should be limited as it can pose a risk to an
    # organization if it is accessed by a bad actor.
    "appengine.disableCodeDownload",

    ####################################################################
    # Cloud Build
    ####################################################################
    "cloudbuild.disableCreateDefaultServiceAccount",

    ####################################################################
    # Cloud Run
    ####################################################################
    # This constraint ensures that an IAM check is required for Cloud Run
    # Without this, the Cloud Run service can be made available to anyone
    # This is similar to adding "allUsers" to IAM. Right now we block allUsers
    # by relying on Domain Restricted Sharing. This helps ensure that control
    # Cannot be avoided by disabling IAM check for Cloud Run
    "run.managed.requireInvokerIam",

    ####################################################################
    # BigQuery
    ####################################################################
    # Reducing attack surface by disabling features/capabilities not intended
    # for use in the environment helps reduce risk. Integration/connection
    # with external services is not in scope nor intended with Isolator.
    "bigquery.disableBQOmniAWS",
    "bigquery.disableBQOmniAzure",

    ####################################################################
    # Cloud Functions
    ####################################################################
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

    ####################################################################
    # Cloud PubSub (Pub/Sub)
    ####################################################################
    # Enforce in-transit regions for Pub/Sub messages
    # Ensures that data transits only within allowed regions for storage policy for topic
    "pubsub.enforceInTransitRegions",

    ####################################################################
    # Cloud SQL
    ####################################################################
    # Isolator does not expect non-RFC1918 access to SQL, thus creating an
    # authorized network is considered as risk as it follows an anti-pattern
    # https://cloud.google.com/sql/docs/mysql/org-policy/org-policy#connection_organization_policies
    "sql.restrictAuthorizedNetworks",

    # Allowing access to Cloud SQL from a public IP creates a data exfiltration
    # Blocking public access via the constraint requires connections to come
    # from internal IPs
    "sql.restrictPublicIp",

    ####################################################################
    # Kubernetes Engine (GKE)
    ####################################################################
    # Require enabling Google Groups for RBAC in GKE clusters.
    "container.managed.enableGoogleGroupsRBAC",

    # Require enabling network policy enforcement in GKE clusters.
    # https://cloud.google.com/kubernetes-engine/docs/how-to/network-policy
    # https://cloud.google.com/kubernetes-engine/docs/how-to/dataplane-v2
    "container.managed.enableNetworkPolicy",

    # Require enabling Security Bulletin Notifications in GKE clusters.
    # https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-notifications#securitybulletin
    "container.managed.enableSecurityBulletinNotifications",

    # Require enabling Workload Identity Federation for GKE.
    # https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
    "container.managed.enableWorkloadIdentityFederation",

    # Disallow using the default Compute Engine service account as the node pool service account.
    # https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#use_least_privilege_sa
    "container.managed.disallowDefaultComputeServiceAccount",

    # Require enabling private nodes in GKE clusters.
    # https://cloud.google.com/kubernetes-engine/docs/how-to/latest/network-isolation#configure-cluster-networking
    "container.managed.enablePrivateNodes",

    # Requires disabling RBAC bindings to system identities in GKE clusters.
    # Disable non-default ClusterRoleBindings and RoleBindings that reference
    # the system:anonymous, system:authenticated, or system:unauthenticated
    # system identities when creating or updating GKE clusters
    # https://cloud.google.com/kubernetes-engine/docs/best-practices/rbac#prevent-default-group-usage
    "container.managed.disableRBACSystemBindings",

    # Require using only the DNS-based endpoint to access GKE clusters.
    # https://cloud.google.com/kubernetes-engine/docs/how-to/latest/network-isolation#dns-based-endpoint
    "container.managed.enableControlPlaneDNSOnlyAccess",

    ####################################################################
    # Compute Engine (GCE)
    ####################################################################
    # Isolator does not support the use of Preview features
    # This disables use of compute preview features
    "compute.managed.blockPreviewFeatures",

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

    ####################################################################
    # Datastream
    ####################################################################
    # Reducing attack surface and blocking internet access to resources in
    # Isolator helps reduce the risk of data exfiltration via these public paths
    "datastream.disablePublicConnectivity",


    ####################################################################
    # Firestore
    ####################################################################
    # Restrict using AppEngine SAfor import/export which can be abused by a bad
    # actor, and limits to Firestore agent. This is the future default so for
    # most cases an unnecessary constraint
    "firestore.requireP4SAforImportExport",

    ####################################################################
    # IAM
    ####################################################################
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
    "iam.managed.disableServiceAccountKeyCreation",
    "iam.managed.disableServiceAccountKeyUpload",

    # Service Consumer Management
    "iam.automaticIamGrantsForDefaultServiceAccounts",

    ####################################################################
    # Cloud Storage (GCS)
    ####################################################################
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

    # Restrict unencrypted HTTP access
    # This boolean constraint, when enforced, explicitly denies HTTP (unencrypted)
    # access to all storage resources. By default, the Cloud Storage XML
    # API allows unencrypted HTTP access.
    "storage.secureHttpTransport",

    ####################################################################
    # Datastream
    ####################################################################
    # Datastream - Block Public Connectivity Methods
    "datastream.disablePublicConnectivity",

    ####################################################################
    # Vertex AI Workbench
    ####################################################################
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


    "ainotebooks.disableTerminal",

    # Workbench vms that are not upgraded can pose a security risk due to
    # security vulnerabilities which are known but unpatched. Requiring an
    # upgrade schedule helps address this risk.
    "ainotebooks.requireAutoUpgradeSchedule",

  ]
}
