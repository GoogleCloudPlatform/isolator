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