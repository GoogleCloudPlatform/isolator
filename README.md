# Isolator

## Overview

**This is not an officially supported Google product**

This repo contains the code to deploy the Google Cloud configuration for
Isolator. Isolator is a solution/blueprint to provide a secure collaboration
environment inside of Google Cloud. This code, along with
the [designs](/design-docs/detailed-design.md) for Isolator
provide the security controls and monitoring for teams to create a secure
isolated
Google Cloud environment where teams may load sensitive data for collaboration
while using zero trust principles and capabilities of Google Cloud to reduce
risk.

Each folder needs to be correlated to it's own Infrastructure as Code
pipeline which will run a Terraform Plan and Terraform Apply. This solution
does not dictate how those pipelines must be setup, the git repo to use, how
triggers should be configured, etc. If standards for IaC pipelines and these
triggers, corresponding Google Cloud service accounts, etc do not exist for
your organization, then it is highly recommended to configure a foundations
before implementing the Isolator solution.

For detailed instructions for how to run each pipeline, please see the README
in each folder.

If you are interested in help with Isolator deployment by Google Cloud
Consulting Professional Services please
see [here](https://cloud.google.com/consulting/portfolio/isolator-secure-sensitive-data-for-collaboration?hl=en)
for more information.

## Security & Compliance

The Isolator designs and corresponding code and configurations **do not**
guarantee a specific level of compliance, nor is that the intent. Given
Isolator's scope is Google Cloud security controls it is impossible to provide
as there are layers of the technology stack outside of Isolator which will come
into play (e.g. IdP configurations, Application Security, Endpoint Security,
etc.).

Isolator is intended to provide a hardened baseline. Similar to the adage "The
most secure environment is one no one can access" Isolator starts from a
position that is locked down. Except for the ingress rule for users to access,
there is not a path to move data in/out of the Isolator environment. Teams
deploying Isolator must create their own unique ingress/egress rules to allow
data movement and any network connectivity. The exact configuration of these
changes can vastly impact the security posture of an environment.

A simple simile:

* Changes to security configurations within Isolator are like
  changes to a firewall rule FW rule. If you open up from a specific IP to a
  specific IP on 443, this is much different than opening 0/0 all ports/protos
  to your entire internal network.

Finally, it is mentioned a few times, but Isolator **does not** replace or
supplement an organizations standard Google Cloud security controls and security
monitoring. For example, Isolator does not provide nor give an opinion on an
organization's SecOps (e.g. CSPM choice, SIEM for log monitoring, etc.).

## Contributions & Testing

Please see [CONTRIBUTING](CONTRIBUTING.md) for details on requirements and how
to contribute.

This repo currently does not have any automated testing. That is, if a
contributor provides a new security controls (e.g. Org Policy) these is not an
automated test it will be run through.

## Pre-requisites

It is highly recommended to review the following prior to starting work on
Isolator:

* Read through [Before You Begin](/design-docs/the-story-before-you-begin.md)
* Read through [Isolator Design](/design-docs/detailed-design.md)
* Complete the Pre-requisites for Isolator (
  See [Checklist](design-docs/implementation-checklist.md) for details)

## Files

Below is the directory tree:

```bash
Isolator
├── 00-pr-req-terraform-samples
├── 01-iso-resource-hierarchy
├── 02-iso-org-policies
├── 03-iso-org-policies
├── 04-iso-security-projects
├── 05-iso-security-projects-resources
├── 06-iso-data-projects
└── 07-iso-data-projects-resources
```

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for details.

## License

Apache 2.0; see [`LICENSE`](LICENSE) for details.

## Disclaimer

This project is not an official Google project. It is not supported by
Google and Google specifically disclaims all warranties as to its quality,
merchantability, or fitness for a particular purpose.

This repository and its contents are not an officially supported Google product.

This design utilizes Google Cloud services. Use of GCP is subject to the Google
Cloud Terms of Service (https://cloud.google.com/terms/). Please review these
terms carefully, as they govern your use of any GCP services implemented based
on this design.