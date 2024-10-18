# 06-iso-data-projects

## Overview

The code contained in "06-iso-data-projects" deploys the project(s) inside the 
data perimeter. To start, for Isolator, only one project is created (the data 
access logs project). While the Isolator security logs (Admin activity) go to 
the Isolator log sink in the security project. The data access logs are kept 
in the data perimeter (these logs may contain sensitive data so they must stay 
in the appropriate perimeter designated for sensitive data). This repo and pipeline 
is intended to also deploy the necessary projects for the use cases for Isolator. 
As these use cases are open ended, no specific project has been created. 

**This step specifically builds out all the projects that will be and can be used within the data perimeter.** 

## Pre-requisites

In order for this pipeline to run correctly the following pre-requisites need to be met

- Terraform CI/CD pipelines must be configured and associated with this code
- The backend.tf file needs to be updated to reflect appropriate backend locations
- The inputs.auto.tfvars file needs to be updated with appropriate values
- The pipelines for Isolator "01-iso-resource-hierarchy", "02-iso-org-policies", "03-iso-vpc-sc", "04-iso-security-projects", and "05-iso-security-projects-resources" should have already been run and deployed
- The Google Cloud service account that this pipeline runs as must have the roles/billing.user assigned to it on the Isolator Host organization billing account.

## Files

Below is a brief overview of the purpose of each file:

```bash
06-iso-data-projects
├── modules
│   ├── data-access-logs-project
│   └── project-creation
├── backend.tf
├── data-access-logs-project.tf
├── inputs.auto.tfvars
├── locals.tf
├── outputs.tf
├── provider.tf
└── variables.tf
```

Note: *Files within modules are omitted*

### backend.tf

This file will reference the backend configuration for this Terraform pipeline (terraform state file). It will also include the refrence to the necessary backends to pull remote state information.

### data-access-logs-project.tf

This file uses modules in the "modules" subdirectory to create a GCP project that store and configure Data Access audit logs.

### inputs.auto.tfvars

This is the file that contains the inputs for the variables set. **Be sure to update this file before running the pipeline.**

### locals.tf

This is the file that contains the locals variables are set. In general these should not be changed.

### outputs.tf

This is the file that outputs the variables required by other pipelines.

### provider.tf

This is the file that sets the requirements for providers and their version.

### variables.f

This is the file which declares the variables used by this pipeline.

### Modules

The Modules provided for this step are as below:

- **data-access-logs-project**: Handles project creation, api enablement and IAM for data access logs project in the data perimeter.
- **project-creation**: Creates a blank project with no owner, editor or viewer. Also Takes a list of apis to enable and enables for a given project.

## Post Pipeline Run Requirements

After this pipeline is run and the projects are deployed the VPC Service Control pipeline (03) MUST BE RUN AGAIN. Without running the VPC Service control pipeline again, these projects will not be properly added to the VPC Service Controls perimeter. Return to 05 to set up proper data access logs for the log project.
