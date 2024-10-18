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
  Provider
 *****************************************/
terraform {
  // Only update if you wish to go to another version, this keeps it within 1.
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    google = {
      source = "hashicorp/google"
      // Update below if you need a feature in a newer version
      // and need to make sure it stays at that newer provider version
      version = ">=4.0.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      // Update below if you need a feature in a newer version
      // and need to make sure it stays at that newer provider version
      version = ">=4.0.0"
    }
  }
}
