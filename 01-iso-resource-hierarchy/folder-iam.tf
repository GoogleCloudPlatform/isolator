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
  Isolator Folder (Top Level)
 *****************************************/
resource "google_folder_iam_policy" "isolator" {
  folder      = var.isolator_folder_id
  policy_data = data.google_iam_policy.isolator_folder.policy_data
}

# Policy Data
data "google_iam_policy" "isolator_folder" {

  # Enable audit logging (read) for all services
  audit_config {
    service = "allServices"
    audit_log_configs {
      log_type = "DATA_WRITE"
    }
    audit_log_configs {
      log_type = "ADMIN_READ"
    }
    audit_log_configs {
      log_type = "DATA_READ"
    }
  }
  # Required for the pipeline managing isolator resource hierarchy (i.e. this pipeline) to have proper permissions
  # to create folders, manage IAM, etc.
  binding {
    role = "roles/resourcemanager.folderAdmin"
    members = [
      "serviceAccount:${var.sa_01_resource_hierarchy}",
    ]
  }
  # Required to allow VPC SC SA to list projects under a folder (so it can then add them to VPC SC perimeter)
  binding {
    role = "roles/browser"
    members = [
      "serviceAccount:${var.sa_03_vpc_sc}",
    ]
  }
  # Required for the pipeline managing isolator resources to create folder level log sinks
  binding {
    role    = "roles/logging.configWriter"
    members = [
      "serviceAccount:${var.sa_05_security_project_resources}",
    ]
  }

  # Required for the pipeline managing isolator resources to create folder level hierarchical firewall rules
  # https://cloud.google.com/firewall/docs/firewall-policies#iam
  binding {
    role    = "roles/compute.orgFirewallPolicyAdmin"
    members = [
      "serviceAccount:${var.sa_05_security_project_resources}",
    ]
  }
  binding {
    role    = "roles/compute.orgSecurityResourceAdmin"
    members = [
      "serviceAccount:${var.sa_05_security_project_resources}",
    ]
  }
  # Allows the Isolator Partner security team to view folers
  binding {
    role = "roles/resourcemanager.folderViewer"
    members = [
      "group:${var.grp_isolator_partner_security_admins}",
    ]
  }
  # Allows the Isolator Partner security team to access the VPC SC troubleshooter to assist with potential VPC SC errors
  binding {
    role = "roles/accesscontextmanager.vpcScTroubleshooterViewer"
    members = [
      "group:${var.grp_isolator_partner_security_admins}",
    ]
  }
  # Allows the Isolator Partner security team to view Org Policies applied to validate if there are any misconfigurations
  binding {
    role = "roles/orgpolicy.policyViewer"
    members = [
      "group:${var.grp_isolator_partner_security_admins}"
    ]
  }
  # Allows the Isolator Partner security team  to view IAM settings in the environment
  binding {
    role = "roles/iam.securityReviewer"
    members = [
      "group:${var.grp_isolator_partner_security_admins}",
    ]
  }
}

/******************************************
  Security Folder
 *****************************************/
resource "google_folder_iam_policy" "isolator_security" {
  folder      = google_folder.isolator_security.folder_id
  policy_data = data.google_iam_policy.isolator_security_folder.policy_data
}

# Policy Data
data "google_iam_policy" "isolator_security_folder" {
  # The below bindings allow the pipelines which are deploying GCP projects for Isolator to have necessary permissions
  # The number of SA's should match (and can be expanded) to match the number of pipelines
  # These are for the isolator security folder only, no pipeline SA managing the data folder should be granted permissions here
  binding {
    role = "roles/resourcemanager.projectCreator"
    members = [
      "serviceAccount:${var.sa_04_security_projects}",
    ]
  }
  binding {
    role = "roles/resourcemanager.projectDeleter"
    members = [
      "serviceAccount:${var.sa_04_security_projects}",
    ]
  }
  # Allows associating billing accounts for project
  binding {
    role = "roles/billing.projectManager"
    members = [
      "serviceAccount:${var.sa_04_security_projects}",
    ]
  }
  # Allows setting IAM for the project
  binding {
    role = "roles/resourcemanager.projectIamAdmin"
    members = [
      "serviceAccount:${var.sa_04_security_projects}",
    ]
  }
  # Allows enablement of APIs
  binding {
    role = "roles/serviceusage.serviceUsageAdmin"
    members = [
      "serviceAccount:${var.sa_04_security_projects}",
    ]
  }
}

/******************************************
  Data Folder
 *****************************************/
resource "google_folder_iam_policy" "isolator_data" {
  folder      = google_folder.isolator_data.folder_id
  policy_data = data.google_iam_policy.isolator_data_folder.policy_data
}

# Policy Data
data "google_iam_policy" "isolator_data_folder" {
  # The below bindings allow the pipelines which are deploying GCP projects for Isolator to have necessary permissions
  # The number of SA's should match (and can be expanded) to match the number of pipelines
  # These are for the isolator data folder only, no pipeline SA managing the security folder should be granted permissions here
  binding {
    role = "roles/resourcemanager.projectCreator"
    members = [
      "serviceAccount:${var.sa_06_data_projects}",
    ]
  }
  binding {
    role = "roles/resourcemanager.projectDeleter"
    members = [
      "serviceAccount:${var.sa_06_data_projects}",
    ]
  }
  # Allows associating billing accounts for project
  binding {
  # Allows associating billing accounts for project
    role = "roles/billing.projectManager"
    members = [
      "serviceAccount:${var.sa_06_data_projects}",
    ]
  }
  # Allows setting IAM for the project
  binding {
    role = "roles/resourcemanager.projectIamAdmin"
    members = [
      "serviceAccount:${var.sa_06_data_projects}",
    ]
  }
  # Allows enablement of APIs
  binding {
    role = "roles/serviceusage.serviceUsageAdmin"
    members = [
      "serviceAccount:${var.sa_06_data_projects}",
    ]
  }
}