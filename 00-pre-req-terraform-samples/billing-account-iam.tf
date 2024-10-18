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
  Billing Member Add
 *****************************************/

# Note this code shows how to add the Isolator SA's as Billing Users but does
# so additive. It is recommended organizations control billing account
# permissions authoritatively.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/billing_account_iam

# 04 Pipeline SA IAM Assignment

#resource "google_billing_account_iam_member" "isolator_04_security_projects_sa_billing_user" {
#  billing_account_id = var.billing_account_id
#  member             = "serviceAccount:${var.sa_04_security_projects}"
#  role               = "roles/billing.user"
#}

# 06 Pipeline SA IAM Assignment

#resource "google_billing_account_ia m_member" "isolator_04_security_projects_sa_billing_user" {
#  billing_account_id = var.billing_account_id
#  member             = "serviceAccount:${var.sa_06_data_projects}"
#  role               = "roles/billing.user"
#}