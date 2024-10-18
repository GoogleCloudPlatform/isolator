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
  Inputs
 *****************************************/
#TODO - Update inputs
isolator_folder_id  = ""
organization_id     = ""

// Domain Identities
// You can run: gcloud organizations list
// In the results you'll see "DIRECTORY_CUSTOMER_ID", use that value for the domains you want to permit in IAM
domain_identities = [
  "", # Most organizations should, by default only use one domain
]

// Domain Contacts
// Enter the email domain(s) of users in this environment.
// ie. "@google.com"
domain_contacts = [
  "",
]

service_account_expiry = [
  "720h",
]
