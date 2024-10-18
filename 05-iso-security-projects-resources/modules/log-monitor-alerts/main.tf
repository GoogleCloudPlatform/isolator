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
  Pub/Sub
 *****************************************/
resource "google_pubsub_topic" "log_alerts_pubsub_topic" {
  name    = "log-alerts-pubsub"
  project = var.project_id

  message_storage_policy {
    allowed_persistence_regions = var.message_storage_region
  }
  message_retention_duration = var.message_retention_time
}

resource "google_pubsub_subscription" "log_alerts_pubsub_subscription" {
  name    = "log-alerts-pubsub-subscription"
  project = var.project_id
  topic   = google_pubsub_topic.log_alerts_pubsub_topic.id

  message_retention_duration   = "604800s"
  retain_acked_messages        = true
  enable_message_ordering      = true
  enable_exactly_once_delivery = true
}

# IAM for allowing folder and org logging service agents to publish to pub/sub
resource "google_pubsub_topic_iam_member" "member_folder_sa" {
  project = var.project_id
  topic   = google_pubsub_topic.log_alerts_pubsub_topic.id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:service-folder-${var.isolator_folder_id}@gcp-sa-logging.iam.gserviceaccount.com"
}

/******************************************
  Notification and Alerts
 *****************************************/
resource "google_monitoring_notification_channel" "group_notification" {
  project      = var.project_id
  display_name = "Isolator Security Group"
  type         = "email"
  labels = {
    email_address = var.grp_isolator_security_team
  }
  force_delete = false
}

resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "Isolator Log Based Alert"
  combiner     = "OR"
  enabled      = true
  project      = var.project_id

  documentation {
    content   = "Please look at the log that triggered this alert and follow the provided playbook. If there are any question please reach out to the Google team. "
    mime_type = "text/markdown"
    subject   = "Issue with your Isolator environment"
  }
  user_labels = {
    isolator = "true"
  }

  conditions {
    display_name = "Isolator Log Alert"
    condition_threshold {
      filter = "resource.type = \"pubsub_subscription\" AND metric.type = \"pubsub.googleapis.com/subscription/num_undelivered_messages\""
      aggregations {
        alignment_period     = "600s"
        cross_series_reducer = "REDUCE_NONE"
        per_series_aligner   = "ALIGN_INTERPOLATE"
      }
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      threshold_value = 0
    }
  }

  notification_channels = [google_monitoring_notification_channel.group_notification.name]
}
