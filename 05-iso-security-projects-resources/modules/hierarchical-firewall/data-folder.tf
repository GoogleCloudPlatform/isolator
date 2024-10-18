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
  Data Folder
 *****************************************/
resource "google_compute_firewall_policy" "data_folder" {
  parent      = "folders/${var.data_folder_id}"
  short_name  = "data-folder-policy"
  description = "The hierarchical firewall rules policy for the Data Folder."
}

resource "google_compute_firewall_policy_rule" "data_folder_deny_all_egress" {
  action          = "deny"
  direction       = "EGRESS"
  description     = "Rule to deny all egress and enable logging"
  firewall_policy = google_compute_firewall_policy.data_folder.name
  priority        = 100000
  disabled        = false
  enable_logging  = true
  match {
    layer4_configs {
      ip_protocol = "all"
    }
    dest_ip_ranges = ["0.0.0.0/0"]
  }
}

resource "google_compute_firewall_policy_rule" "data_folder_allow_all_internal_egress" {
  action          = "allow"
  direction       = "EGRESS"
  description     = "Rule to allow internal (RFC1918) egress and enable logging"
  firewall_policy = google_compute_firewall_policy.data_folder.name
  priority        = 90000
  disabled        = false
  enable_logging  = true
  match {
    layer4_configs {
      ip_protocol = "tcp"
    }
    layer4_configs {
      ip_protocol = "udp"
    }
    dest_ip_ranges = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

resource "google_compute_firewall_policy_rule" "data_folder_allow_443_to_restricted_vip_egress" {
  action          = "allow"
  direction       = "EGRESS"
  description     = "Rule to allow restricted VIP egress and enable logging"
  firewall_policy = google_compute_firewall_policy.data_folder.name
  priority        = 90100
  disabled        = false
  enable_logging  = true
  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports       = [443]
    }
    dest_ip_ranges = [
      "199.36.153.4/30",
    ]
  }
}
