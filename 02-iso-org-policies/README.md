# 02-iso-org-policies

## Overview

The code contained in "02-iso-org-policies" is intended to configure Google Cloud
 Organizational Policies for Isolator. These policies will help set the guardrails 
to protect Google Cloud resources deployed within Isolator.

**This step specifically creates all the Organization Policies for folder and project resources under Isolator Folder.**

## Pre-requisites

In order for this pipeline to run correctly the following pre-requisites need to be met:

* Terraform CI/CD pipelines must be configured and associated with this code
* The backend.tf file needs to be updated to reflect appropriate backend locations
* The inputs.auto.tfvars file needs to be updated with appropriate values
* The pipelines for 01-iso-resource-hierarchy should have already been run and deployed
* The Google Cloud service account that this pipeline runs as must have the roles/orgpolicy.policyAdmin assigned to it at the Org Node.

## Files

Below is the directory tree and brief overview of the purpose each files:

```bash
02-iso-org-policies
├── modules
│   ├── org-policy-bool
│   ├── org-policy-custom-gke
│   └── org-policy-default
├── backend.tf
├── inputs.auto.tfvars
├── locals.tf
├── org-policies-cmek.tf
├── org-policies-isolator-folder.tf
├── org-policies-sub-isolator-folders.tf
├── provider.tf
└── variables.tf
```

### backend.tf

This file will reference the backend configuration for this Terraform pipeline (terraform state file). It will also include the refrence to the necessary backends to pull remote state information.

### inputs.auto.tfvars

This is the file that contains the inputs for the variables set.\
**Be sure to update this file before running the pipeline.**

### locals.tf

This is the file that contains the locals variables are set. In general these should not be changed.

### modules/org-policy-bool

Module that enforces specific boolean values for Google Cloud Platform organization policies.

### modules/org-policy-custom-gke

Creates and applies custom Org Policies for GKE.

### org-policies-isolator-folder.tf

This file contains the Terraform code to enforce the appropriate Org Policies for Isolator under the top-level Isolator folder. This code also ensures that any Org Policies which are not enforced are kept at the Google default setting.

### org-policies-sub-isolator-folder.tf

This file contains the Terraform code to enforce the appropriate Org Policies for Isolator under Security and Data folders under the main Isolator folder. This code allows Org Policies to be altered for specific use cases under the Data and Security folders that would need to be different from policies enforced at the Isolator folder level.

### provider.tf

This is the file that sets the requirements for providers and their version.

### variables.tf

This is the file which declares the variables used by this pipeline.

## Post Pipeline Run Requirements

There are no post pipeline run requirements for this pipeline.