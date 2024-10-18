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
  GCB Private Pool
 *****************************************/
variable "isolator_folder_id" {
  description = "The Google Cloud Folder ID for the folder created for the Isolator environment"
}

variable "isolator_org_id" {
  description = ""
}

# Note this group is for the Isolator Partner security team. It is not the same
# as the group where they have been provided identities in the host organization.
# Rather this is used to recieve notitications of changes to the enivonrment
# Thus it will not be @hostorganization but rather @partnerorganization
variable "grp_isolator_partner_security_team_external" {
  description = "The group that will contain the Isolator Security Admins to receive alerts."
}

# Note this group is for the Isolator Partner security team. It is assumed the
# Isolator Host security team already has required access to the environment from
# higher in the Google Cloud resource hierarchy.
# Note, unlike the above group, this is the group created and managed by the
# host organization.
variable "grp_isolator_partner_security_admins" {
  description = "The group that will contain the Isolator Partner Security Admins."
}
