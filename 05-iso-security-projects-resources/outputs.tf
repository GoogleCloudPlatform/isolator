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
  Outputs
 *****************************************/
output "isolator_folder_log_sink_log_writer_identity" {
  # There is one writer identity per folder so once we have this we don't need to
  # keep capturing for additional Isolator Folder log sinks
  # Note, this same identity will be referenced for the data logs as well because
  # When creating a GCP log sink for a folder, all sinks for that folder have
  # the same identity. Thus, while there are two sinks (security & data access logs)
  # this same identity will be used to write logs for both sinks. This will be used
  # in the VPC SC pipeline to allow ingress to the security perimeter for security logs
  # and to the data perimter for data logs
  value = module.security_log_bucket_and_sink.log_sink_writer_identity
}

output "isolator_folder_log_sink_security_log_bucket_id" {
  # This will be a useful output to use when creating the necessary Org Node
  # Log sink (It needs to know the destination bucket ID)
  value = module.security_log_bucket_and_sink.log_bucket_id
}