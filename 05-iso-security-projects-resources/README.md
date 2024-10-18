# 05-iso-security-projects-resources

## Overview

The code contained in "05-iso-security-projects-resources" creates the Google 
Cloud resources that log, monitor, and protect the Isolator environment. This 
includes Hierarchical Firewall rules, log sinks to collect logs, and monitoring 
of the security logs for specific security events.

**This step specifically creates the all the security resources that is deployed within the security projects (in security perimeter).**


## Pre-requisites

In order for this pipeline to run correctly the following pre-requisites need to be met

- Terraform CI/CD pipelines must be configured and associated with this code
- The backend.tf file needs to be updated to reflect appropriate backend locations
- The inputs.auto.tfvars file needs to be updated with appropriate values
- The pipelines for Isolator "01-iso-resource-hierarchy", "02-iso-org-policies", "03-iso-vpc-sc", and "04-iso-security-projects" should have already been run and deployed
- If modules are not stored locally, update the reference location

## Files

Below is a brief overview of the purpose of each file:

```bash
├── backend.tf
├── hierarchical-firewall.tf
├── inputs.auto.tfvars
├── locals.tf
├── log-bucket-log-sinks.tf
├── log-monitoring.tf
├── modules
│   ├── empty-gcs-prj-lien
│   ├── hierarchical-firewall
│   ├── log-bucket-log-sink
│   ├── log-monitor-alerts
├── outputs.tf
├── provider.tf
└── variables.tf
```

Note: *Files within modules are omitted*

### backend.tf

This file will reference the backend configuration for this Terraform pipeline (terraform state file).  It will also include the refrence to the necessary backends to pull remote state information.

### hierarchal-firewall.tf

This file will create the hierarchal firewall rules enforced at folder levels.

### inputs.auto.tfvars

This is the file that contains the inputs for the variables set. Be sure to update this file before running the pipeline.

### locals.tf

This is the file that contains the locals variables are set. In general these should not be changed.

### log-bucket-log-sinks.tf

This is the file that creates the Isolator log bucket and the sinks that send logs to the logging bucket.

### log-monitoring.tf

This is the file that creates the Isolator log monitoring resources such as pub/sub and sinks that send offending logs to the pub/sub, which then triggers an alert.

### outputs.tf

This is the file that outputs the variables required by other pipelines.

### provider.tf

This is the file that sets the requirements for providers and their version.

### variables.tf

This is the file which declares the variables used by this pipeline.

### Modules

The Modules provided in this step are described below:

```bash
binary-authorization
│   ├── empty-gcs-prj-lien
│   ├── hierarchical-firewall
│   ├── log-bucket-log-sink
│   ├── log-monitor-alerts
```

- **empty-gcs-prj-lien**: Provides anti-project deletion support by inserting an empty, locked bucket into each project.
- **hierarchical-firewall**: Creates hierarchal firewall rules at the folder level which are thus enforced on all projects within Isolator.
- **log-bucket-log-sink**: Creates the Isolator log bucket and the sinks that send logs to the logging bucket.
- **log-monitoring**: Creates the Isolator log monitoring resources such as pub/sub and sinks that send offending logs to the pub/sub, which then triggers an alert.

## Post Pipeline Run Requirements

After this pipeline is run and the log sinks are deployed the VPC Service Control pipeline MUST BE RUN AGAIN. Without running the VPC Service control pipeline again, these projects will not be properly added to the VPC Service Controls perimeter. You will have to return to this pipeline after running 06 as well, to include data access logs that is enabled in 06.
