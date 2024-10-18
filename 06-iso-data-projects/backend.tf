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
  Backend State Reference
 *****************************************/
# TODO - Edit below with appropriate backend (does not need to be GCS)
# Multiple options for backend.
# See https://developer.hashicorp.com/terraform/language/backend for more information
terraform {
  backend "gcs" {
    bucket = ""
    prefix = ""
  }
}

/******************************************
  Remote State References
 *****************************************/
# TODO - Edit below with remote state backends
# Note, while they do not have to be a GCS backend, if you edit the name
# of the resources (e.g. rs_01_resource_hierarchy) then you'll need to go to the
# code to update that backend reference. It's not recommended to rename these
data "terraform_remote_state" "rs_01_iso_resource_hierarchy" {
  backend = "gcs"
  config = {
    bucket = ""
    prefix = ""
  }
}
