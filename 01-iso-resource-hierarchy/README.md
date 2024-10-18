# 01-iso-resource-hierarchy

## Overview

The code contained in this folder "01-iso-resource-hierarchy" is intended to
manage the Google Cloud folder structure and IAM for Isolator.
It should be connected to the Infrastructure as Code pipelines which will run
Terraform plan and Terraform apply. Depending on pipeline configurations, the
plan and apply can be triggered by pull requests (PRs) as the change mechanism
for all infrastructure updates.\

**This step specifically builds out "security" and "data" sub-folders under
Isolator.**

## Pre-requisites

In order for this pipeline to run correctly the following pre-requisites need to
be met:

* Terraform CI/CD pipelines must be configured and associated with this code

* Terraform plan and Terraform plan pipelines must be configured and associated
  with this code
* The backend.tf file needs to be updated to reflect appropriate backend
  locations
* The inputs.auto.tfvars file needs to be updated with appropriate values
* A folder must already be created (Ideally named "Isolator")
* The Google Cloud service account that this pipeline runs as must have the
  roles/resourcemanager.folderAdmin assigned to it on the Isolator folder

## Files

Below is the directory tree and brief overview of the purpose each files:

```bash
01-iso-resource-hierarchy
├── backend.tf
├── folder-iam.tf
├── folder.tf
├── inputs.auto.tfvars
├── outputs.tf
├── provider.tf
└── variables.tf
```

### backend.tf

This file will reference the backend configuration for this Terraform pipeline (
terraform state file). It will also include any necessary references to other
backends to pull remote state information.

### folder-iam.tf

This file contains the code which will maintain the IAM permissions for the
Isolator folder and any folders underneath it. All folder policies will be
manage authoritatively.

### folders.tf

This file contains the code which will create appropriate folders under the
Isolator folder.

### inputs.auto.tfvars

This is the file that contains the inputs for the variables set.\
**Be sure to update this file before running the pipeline.**

### outputs.tf

This is the file that outputs the variables required by other pipelines.

### provider.tf

This is the file that sets the requirements for providers and their version.

### variables.tf

This is the file which declares the variables used by this pipeline.

## Post Pipeline Run Requirements

There are no post pipeline run requirements for this pipeline.