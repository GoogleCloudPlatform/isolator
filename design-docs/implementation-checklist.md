Copyright 2024 The Isolator Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


## Overview

**This is not an officially supported Google product**

This is intended to help be a very brief checklist of activities required to
deploy Isolator. For each step specific please refer to the relevant code,
designs, etc. 

## Checklist

### Pre-Reqs
1. Create Isolator Security Admins Group in Host Organization
2. Enable Access Transparency Logs
3. Establish Isolator IaC Pipelines
4. Create Isolator Google Cloud Folder
5. Create Scoped Access Context Manager Policy
6. Create and add VPC SC Ingress Rule for IaC Pipelines
7. Create custom role for HFW Rules at Org Node
8. Grant Isolator IaC Pipeline Service Accounts necessary IAM permissions
9. Create Isolator OU in Cloud Identity
10. Prepare devices (VDI, Laptops, etc.)

### Cloud Identity
1. Disable unnecessary services for Isolator OU
2. Configure Cloud Session Length (Isolator OU)
3. Disable Cloud Shell (Isolator OU)
4. Configure Chrome Policies (Isolator OU)
5. Configure Endpoint Verification (Isolator OU)
6. Add company owned assets to inventory 
7. Purchase Chrome Enterprise Premium Licensing
8. Assign auto licensing for Chrome Enterprise Premium (Isolator OU)
9. Create group to receive alerts (Partner Organization)
10. Configure Alert for changes to Isolator OU

### Google Cloud
1. Run 01 Pipeline
2. Run 02 Pipeline
3. Run 03 Pipeline
4. Run 04 Pipeline
5. Rerun 03 Pipeline
6. Run 05 Pipeline
7. Rerun 03 Pipeline (Uncomment code)
8. Run 06 Pipeline
9. Rerun 03 Pipeline
10. Rerun 05 Pipeline (uncomment code)
11. Create Org Node Log Sinks (code in 00 folder)
12. Rerun 03 Pipeline (uncomment code)
13. Rerun 05 pipeline (uncomment code)