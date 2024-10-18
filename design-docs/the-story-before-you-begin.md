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


# Isolator: Secure Collaboration on Google Cloud

**This is not an officially supported Google product**

## What's the Story? What is it?

Isolator, announced at Google Cloud Next
‘24 ([Blog](https://cloud.google.com/blog/products/identity-security/introducing-isolator-a-new-tool-to-enable-secure-collaboration-with-healthcare-data-next24)),
introducing customers to Google’s answer on how different parties can
collaborate securely on Google Cloud.

## Isolator Released

**What is Isolator?**

Products
Isolator makes use of a variety of Google capabilities and security features
such as:

- Cloud-managed Chrome Browser
    - [Overview](https://chromeenterprise.google/browser/management/)
    - [Chrome Browser Cloud Management](https://support.google.com/chrome/a/answer/9116814?hl=en&visit_id=638339183651651644-1518011390&ref_topic=9301744&rd=1)
    - [Set Chrome policies for users or browsers](https://support.google.com/chrome/a/answer/2657289?hl=en&ref_topic=9027936)
    - [Chrome Browser Cloud Management Agreement](https://chromeenterprise.google/terms/chrome-browser-cloud-management/)
- Cloud Identity Free
    - [What is Cloud Identity](https://support.google.com/cloudidentity/answer/7319251?hl=en)
    - [Pricing](https://cloud.google.com/identity/pricing)
- [Chrome Enterprise Premium (CEP)](https://chromeenterprise.google/products/chrome-enterprise-premium/)
- [Access Context Manager](https://chromeenterprise.google/products/chrome-enterprise-premium/)
    - [VPC Service Controls](https://cloud.google.com/vpc-service-controls/docs/overview)
    - [Access Levels](https://cloud.google.com/access-context-manager/docs/overview#access-levels)
- [Organization Policy Service](https://cloud.google.com/resource-manager/docs/organization-policy/overview)
- [VPCs](https://cloud.google.com/vpc/docs/overview)
    - [Hierarchical firewall policies](https://cloud.google.com/firewall/docs/firewall-policies)
    - [DNS](https://cloud.google.com/dns/docs/overview) & [Routing](https://cloud.google.com/vpc/docs/routes#routing_in)
- [Identity & Access Management](https://cloud.google.com/iam/docs/overview)
- [Logging](https://cloud.google.com/logging/docs/overview)
- [Monitoring](https://cloud.google.com/monitoring/docs/monitoring-overview)
- [Service Accounts](https://cloud.google.com/iam/docs/service-account-overview)

# Before you begin

Isolator is a solution to enable secure collaboration on Google Cloud and it has
prerequisites before it can be deployed in your environment. Please review the
requirements before moving forward with implementation of Isolator.

**Infrastructure as Code (Terraform) Pipelines**

Isolator requires IaC pipelines to deploy and manage the Google Cloud
environment. There are a variety of solutions which may be used to configure and
deploy Google Cloud infrastructure via IaC pipelines. An example of using Cloud
Build may be
found [here](https://cloud.google.com/docs/terraform/resource-management/managing-infrastructure-as-code).

**Cloud Identity & Google Cloud Organization**

Isolator requires an existing Google Cloud Identity and Google Cloud
Organization to setup and configure necessary identities and cloud resources.
See [here](https://cloud.google.com/resource-manager/docs/creating-managing-organization)
for more information.

**Billing**

Isolator deploys resources with cost implications and requires an active Google
Cloud billing account to associate these costs.
See [here](https://cloud.google.com/billing/docs/how-to/create-billing-account)
for more information.

# Design

After going through the above, please
review [Isolator design](detailed-design.md).