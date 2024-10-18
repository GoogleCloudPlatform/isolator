# 07-iso-data-projects-resources

## Overview

The code contained in "07-iso-data-projects-resources" deploys the security 
resources for Isolator that reside in the data perimeter. Specifically, the 
data access logs sink. 

**This step specifically builds out all the resources that goes within the data projects within the data perimeter.**

## Pre-requisites

In order for this pipeline to run correctly the following pre-requisites need to be met

- Terraform CI/CD pipelines must be configured and associated with this code
- The backend.tf file needs to be updated to reflect appropriate backend locations
- The inputs.auto.tfvars file needs to be updated with appropriate values
- The pipelines for Isolator "01-iso-resource-hierarchy", "02-iso-org-policies", "03-iso-vpc-sc", "04-iso-security-projects", "05-iso-security-projects-resources", and "06-iso-data-projects" should have already been run and deployed

## Files

Below is a brief overview of the purpose of each file:

```bash
07-iso-data-projects-resources
├── modules
├── backend.tf
├── inputs.auto.tfvars
├── locals.tf
├── outputs.tf
├── provider.tf
└── variables.tf
```

### modules

A sub directory to store modules.

### backend.tf

This file will reference the backend configuration for this Terraform pipeline (terraform state file). It will also include the refrence to the necessary backends to pull remote state information.

### inputs.auto.tfvars

This is the file that contains the inputs for the variables set. **Be sure to update this file before running the pipeline.**

### locals.tf

This is the file that contains the locals variables are set. In general these should not be changed.

### outputs.tf

This is the file that outputs the variables required by other pipelines.

### provider.tf

This is the file that sets the requirements for providers and their version.

### variables.tf

This is the file which declares the variables used by this pipeline.

## Post Pipeline Run Requirements

None for now.
