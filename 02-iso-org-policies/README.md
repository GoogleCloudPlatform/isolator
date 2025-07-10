# 02-iso-org-policies

## Overview

The code contained in "02-iso-org-policies" is intended to configure Google Cloud
 Organizational Policies for Isolator. These policies will help set the guardrails 
to protect Google Cloud resources deployed within Isolator. Note, Google has released
what are called ["Managed Constraints."](https://cloud.google.com/resource-manager/docs/organization-policy/using-constraints#managed-constraints)
Isolator will migrate or change policies to use managed over time. The intent is 
to ensure Isolator can take advantage of the latest capabilities of managed policies. 

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
│   ├── custom-org-policy-apply
│   ├── custom-org-policy-create
│   └── org-policy-bool
│   └── org-policy-default
├── backend.tf
├── inputs.auto.tfvars
├── locals.tf
├── create-custom-org-policies.tf
├── isolator-folder-set-to-default.tf
├── isolator-folder-list.tf
├── isolator-folder-bool-custom.tf
├── data-folder.tf
├── security-folder.tf
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

### modules/custom-org-policy-apply

Applies the custom org policies provided

### modules/custom-org-policy-create

Creates the custom org policies provided

### modules/org-policy-default

Takes the list of org policies and resets them to Google Default. This helps avoid potential issues of undesired constraints. 

### create-custom-org-policies.tf

This file contains the Terraform code for the required custom org policies. NOTE it is HIGHLY RECOMMENDED that these custom policies are created and maintained outside of Isolator so that they can be maintained and used outside of the lifecycle of Isolator. That is, if these are created in Isolator, and another part of the organization uses them, but then the Isolator environment is torn down, it can cause issues for the other parts of the environment.

### isolator-folder-set-to-default.tf

This file contains the Terraform code to set Org Policies that are not supposed to be enforced for Isolator and resets them to Google Default. 

### isolator-folder-list.tf

This file contains the Terraform code to enforce the desired list constraints for Isolator at the Isolator folder level. 

### isolator-folder-bool-custom.tf

This file contains the Terraform code to enforce the custom and boolean constraints for Isolator at the Isolator folder level. 

### data-folder.tf

This file contains the Terraform code to enforce the constraints for the Data Folder for Isolator.

### security-folder.tf

This file contains the Terraform code to enforce the constraints for the Security Folder for Isolator.

### provider.tf

This is the file that sets the requirements for providers and their version.

### variables.tf

This is the file which declares the variables used by this pipeline.

## Post Pipeline Run Requirements

There are no post pipeline run requirements for this pipeline.