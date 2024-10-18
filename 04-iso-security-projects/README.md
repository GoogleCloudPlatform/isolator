# 04-iso-security-projects

## Overview

The code contained in "04-iso-security-projects" deploys the Google Cloud 
project which will host the resources necessary for security logging and 
monitoring of the Isolator environment. 

**This step specifically creates the all projects within the security perimeter.** Patterns include:

- Security Logs Project (required)
- Secure Cloud Build Project (required)
- Googler Removal Project (required)

## Pre-requisites

In order for this pipeline to run correctly the following pre-requisites need to be met

- Terraform CI/CD pipelines must be configured and associated with this code
- The backend.tf file needs to be updated to reflect appropriate backend locations
- The inputs.auto.tfvars file needs to be updated with appropriate values
- The pipelines for Isolator "01-iso-resource-hierarchy", "02-iso-org-policies", and "03-iso-vpc-sc" should have already been run and deployed
- The Google Cloud service account that this pipeline runs as must have the roles/billing.user assigned to it on the Isolator Host organization billing account.


## Files

Below is the directory tree and brief overview of the purpose each files:

```bash
04-iso-security-projects
├── backend.tf
├── inputs.auto.tfvars
├── locals.tf
├── modules
│   ├── project-creation
│   └── security-log-project
├── outputs.tf
├── provider.tf
├── README.md
├── security-log-project.tf
└── variables.tf
```

Note: *Files within modules are omitted*

### backend.tf

This file will reference the backend configuration for this Terraform pipeline (terraform state file). It will also include the refrence to the necessary backends to pull remote state information.

### inputs.auto.tfvars

This is the file that contains the inputs for the variables set.\
**Be sure to update this file before running the pipeline.**

### locals.tf

This is the file that contains the locals variables are set. In general these should not be changed.

### outputs.tf

This is the file that outputs the variables required by other pipelines.

### provider.tf

This is the file that sets the requirements for providers and their version.

### security-log-project.tf

This file uses the security-log-project module in the "modules" subdirectory to create a GCP project made to store logs and monitoring related resources.

### variables.tf

This is the file which declares the variables used by this pipeline.

### Modules

The Modules provided for this step are as below:

- **project-creation**: Common module used to create new projects. It also enables the required APIs and creates the required IAM bindings for each project.
- **security-log-project**: Creates a project with proper IAM permissions and APIs enabled for logs and monitoring.

## Post Pipeline Run Requirements

After this pipeline is run and the log sinks are deployed the VPC Service Control pipeline MUST BE RUN AGAIN. Without running the VPC Service control pipeline again, these projects will not be properly added to the VPC Service Controls perimeter.
