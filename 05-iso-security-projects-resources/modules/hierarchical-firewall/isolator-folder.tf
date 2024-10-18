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
  Isolator Folder
 *****************************************/
resource "google_compute_firewall_policy" "isolator_folder" {
  parent      = "folders/${var.isolator_folder_id}"
  short_name  = "isolator-folder-policy"
  description = "The hierarchical firewall rules policy for the Isolator Folder. "
}

resource "google_compute_firewall_policy_rule" "iso_folder_deny_all_ingress" {
  action          = "deny"
  direction       = "INGRESS"
  description     = "Rule to deny all ingress and enable logging"
  firewall_policy = google_compute_firewall_policy.isolator_folder.name
  priority        = 100000
  disabled        = false
  enable_logging  = true
  match {
    layer4_configs {
      ip_protocol = "all"
    }
    src_ip_ranges = ["0.0.0.0/0"]
  }
}

resource "google_compute_firewall_policy_rule" "iso_folder_go_next_for_internal_ingress" {
  action          = "goto_next"
  direction       = "INGRESS"
  description     = "Rule to go to next for internal (rfc1918) ingress for tcp and udp."
  firewall_policy = google_compute_firewall_policy.isolator_folder.name
  priority        = 90000
  disabled        = false
  match {
    layer4_configs {
      ip_protocol = "tcp"
    }
    layer4_configs {
      ip_protocol = "udp"
    }
    src_ip_ranges = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

resource "google_compute_firewall_policy_rule" "iso_folder_go_next_for_healthcheck_services_ingress" {
  action          = "goto_next"
  direction       = "INGRESS"
  description     = "Rule to go to next for ingress for LB health checks."
  firewall_policy = google_compute_firewall_policy.isolator_folder.name
  priority        = 90100
  disabled        = false
  match {
    layer4_configs {
      ip_protocol = "tcp"
    }
    src_ip_ranges = [
      "35.191.0.0/16",
      "130.211.0.0/22",
    ]

  }
}

resource "google_compute_firewall_policy_rule" "iso_folder_go_next_for_iap_ssh_ingress" {
  action          = "goto_next"
  direction       = "INGRESS"
  description     = "Rule to go to next for ingress for SSH over IAP."
  firewall_policy = google_compute_firewall_policy.isolator_folder.name
  priority        = 90200
  disabled        = false
  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports       = [22]
    }
    src_ip_ranges = [
      "35.235.240.0/20",
    ]
  }
}

resource "google_compute_firewall_policy_rule" "iso_folder_go_next_for_serverless_vpc_access_ingress" {
  action          = "goto_next"
  direction       = "INGRESS"
  description     = "Rule to go to next for ingress for Serverless VPC Access."
  firewall_policy = google_compute_firewall_policy.isolator_folder.name
  priority        = 90300
  disabled        = false
  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports       = [443]
    }
    src_ip_ranges = [
      "35.199.224.0/19",
    ]
  }
}
