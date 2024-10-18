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
  Data Perimeter
 *****************************************/
/* The below code allows us to pull all project numbers from under the data
  folder and filter to active projects only. This provides the data we need to
  build our list of projects which need to be in the data perimeter.
  that is, if a project is under the data folder it will be under the
  data VPC SC perimeter. */

# NOTE: this does not recursively go through folders under the data folder.
# The variable used "data_folder_numbers" coming from the resource hierarchy
# pipeline (see locals below) should included the data folder and any folders under it.
data "google_projects" "data_projects" {
  for_each = toset(local.data_folder_numbers)
  filter   = "parent.id:${each.value} lifecycleState:ACTIVE"
}


locals {
  # The below helps us feed the necessary folder numbers to our above data block
  data_folder_numbers = data.terraform_remote_state.rs_01_iso_resource_hierarchy.outputs.data_folder_id_list

  # The below helps us create a list of project numbers we'll need for our perimeter

  project_numbers_data = flatten([for num in local.data_folder_numbers : data.google_projects.data_projects[num].projects[*].number])

  # The below helps us take the project numbers in our list and format them for the
  # perimeter by adding "projects/" before each
  project_numbers_data_formatted = formatlist("projects/%s", local.project_numbers_data)
}

resource "google_access_context_manager_service_perimeter" "isolator_data" {
  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/servicePerimeters/isolator_data"
  title  = "isolator_data"

  status {
    restricted_services = local.restricted_services_list

    vpc_accessible_services {
      enable_restriction = true
      allowed_services   = ["RESTRICTED-SERVICES"]
    }

    resources = local.project_numbers_data_formatted

    /* The below block is to allow Isolator users to access projects inside the
      Isolator data perimeter. It follows the device requirements defined for devices.
      The list of users will be maintained as an input.
      Note, in case of an alert in Isolator about a security issue the security
      team members responsible for removing access should comment
      Out the below ingress rule (ingress_policies block) to remove access
      until the issue is resolved */
    ingress_policies {
      ingress_from {
        identities = var.approved_data_users
        sources {
          access_level = google_access_context_manager_access_level.meets_all_isolator_device_conditions.name
        }
      }
      ingress_to {
        operations {
          # * allows all services
          service_name = "*"
          # We don't list methods as we're allowing all services
        }
        # * allows access to all projects (resources)
        resources = ["*"]
      }
    }


    # TODO Uncomment the below after running the 06 pipeline
    # While the writing of data access logs will not occur prior to running
    # the 07 pipeline, the SA identity for our log sink is the same as the 04
    # Thus we only need the data project created before we run this
    # Data Access Logs - Logging Bucket ingress

    #      ingress_policies {
    #        ingress_from {
    #          identities = [
    #            # This is the identity created for Isolator Log Folder Sink (data access logs)
    #            local.log_bucket_log_sink_isolator_folder_log_writer_identity,
    #          ]
    #          sources {
    #            access_level = "*"
    #          }
    #        }
    #        ingress_to {
    #          operations {
    #            # allow specific services
    #            service_name = "logging.googleapis.com"
    #            method_selectors {
    #              method = "LoggingServiceV2.WriteLogEntries"
    #            }
    #          }
    #          resources = [local.data_access_logs_project_number_formatted]
    #        }
    #      }

  }
}