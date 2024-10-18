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
  Security Perimeter
 *****************************************/
/* The below code allows us to pull all project numbers from under the security
  folder and filter to active projects only. This provides the data we need to
  build our list of projects which need to be in the security perimeter.
  that is, if a project is under the security folder it will be under the
  security VPC SC perimeter.

  NOTE: this does not recursively go through folders under the security folder.
  The variable used "security_folder_numbers" coming from the resource hierarchy
  pipeline (see locals below) should included the data folder and any folders under it. */
data "google_projects" "security_projects" {
  for_each = toset(local.security_folder_numbers)
  filter   = "parent.id:${each.value} lifecycleState:ACTIVE"
}

locals {
  # The below helps us feed the necessary folder numbers to our above data block
  security_folder_numbers = data.terraform_remote_state.rs_01_iso_resource_hierarchy.outputs.security_folder_id_list
  # The below helps us create a list of project numbers we'll need for our perimeter
  project_numbers_security = flatten([for num in local.security_folder_numbers : data.google_projects.security_projects[num].projects[*].number])
  # The below helps us take the project numbers in our list and format them for the
  # perimeter by adding "projects/" before each
  project_numbers_security_formatted = formatlist("projects/%s", local.project_numbers_security)
}


resource "google_access_context_manager_service_perimeter" "isolator_security" {
  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/servicePerimeters/isolator_security"
  title  = "isolator_security"

  status {
    restricted_services = local.restricted_services_list

    resources = local.project_numbers_security_formatted

    # The below block is to allow security users to access projects inside the
    # Isolator security perimeter. It follows the same requirements for devices
    # as the data perimeter. The list of users will be maintained as an input.
    ingress_policies {
      ingress_from {
        identities = var.approved_security_users
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

    # TODO: Uncomment after pipeline 05 runs and creates necessary sinks. (Wait to create org level sinks too)

    # /* The following is required to allow our log sinks to function properly.
    #   The code must stay commented out until the Isolator log sink pipeline
    #   is run and the org node org sinks are created because the SA's for the log sink
    #   will not exist until we create the sink itself. */
    # ingress_policies {
    #   ingress_from {
    #     identities = [
    #       # This is the identity created for Isolator Log Folder Sink
    #       local.log_bucket_log_sink_isolator_folder_log_writer_identity,
    #       # This is the identity created for the Org Node sink for Isolator
    #       "serviceAccount:${var.isolator_log_bucket_log_sink_org_node_writer}",
    #     ]
    #     sources {
    #       access_level = "*"
    #     }
    #   }
    #   ingress_to {
    #     operations {
    #       # allow specific services
    #       service_name = "logging.googleapis.com"
    #       method_selectors {
    #         method = "*"
    #         # Health check method not supported
    #         # google.internal.cloud.logging.bucketaccess.v1internal.BucketAccess.Check
    #         # https://cloud.google.com/vpc-service-controls/docs/supported-method-restrictions
    #       }
    #     }
    #     operations {
    #       # allow specific services
    #       service_name = "pubsub.googleapis.com"
    #       method_selectors {
    #         method = "Publisher.Publish"
    #       }
    #     }
    #     resources = [local.logs_and_monitoring_project_number_formatted]
    #   }
    # }

  }
}