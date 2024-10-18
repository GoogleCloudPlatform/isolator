# 03-iso-vpc-sc

## Overview

The code contained in "03-iso-vpc-sc" deploys the VPC Service Controls configuration
for Isolator. It creates the Security perimeter and the Data perimeter. It 
is setup to be re-run every time a new project is created under either the 
"Security" or the "Data" folders and then automatically add those projects to the 
respective perimeter. It also creates the necessary ingress rules to allow access 
to the environment. This includes the Access Levels necessary to restrict user 
access to those users which are coming from a corporate owned device and from 
Managed Chrome Browser. 

**This step specifically creates the VPC Service Controls perimeters that conviniently matches the folder resource structure: data and security.**

## Pre-requisites

In order for this pipeline to run correctly the following pre-requisites need to be met:

* Terraform CI/CD pipelines must be configured and associated with this code
* The backend.tf file needs to be updated to reflect appropriate backend locations
* The inputs.auto.tfvars file needs to be updated with appropriate values
* The pipelines for 01-iso-resource-hierarchy and 02-iso-org-policies should have already been run and deployed for the
  initial run
* The Google Cloud service account that this pipeline runs as must have the roles/accesscontextmanager.policyAdmin assigned to it at the scoped Access Context Manager policy.

## Files

Below is the directory tree and brief overview of the purpose each files:

```bash
03-iso-vpc-sc
├── access-levels.tf
├── acm-policy-iam.tf
├── backend.tf
├── inputs.auto.tfvars
├── locals.tf
├── perimeter-data.tf
├── perimeter-security.tf
├── provider.tf
└── variables.tf
```

### access-levels.tf

This file contains the Access Context Manager access levels to be used by the VPC Service Controls perimeters to allow specified ingress. Access levels are applied to perimeters via ingress rules and, in general, are not applied directly to a perimeter.

### acm-policy-iam.tf

This file contains IAM bindings to allow the Isolator security team to view Access Context Manager policies and troubleshoot VPC-SC errors.

### backend.tf

This file will reference the backend configuration for this Terraform pipeline (terraform state file). It will also include the refrence to the necessary backends to pull remote state information.

### inputs.auto.tfvars

This is the file that contains the inputs for the variables set. Be sure to update this file before running the pipeline.

### locals.tf

This is the file that contains the locals variables are set. In general these should not be changed.

### perimeter-data.tf

This file contains the creation of the perimeter which will host Isolator data and support use cases. This perimeter will contain projects under the data folder.

### perimeter-security.tf

This file contains the creation of the perimeter which will host Isolator security resources. This perimeter will contain projects under the security folder.

### provider.tf

This is the file that sets the requirements for providers and their version.

### variables.tf

This is the file which declares the variables used by this pipeline.

## Post Pipeline Run Requirements

Isolator pipelines for project creation and resource creation will run after this pipeline is complete. It is important to come back to this pipeline to rerun it to add new projects or enable new use cases. For the log sink use cases an ingress rule has already been created but is commented out for the first run. After the log sinks are created the code in the perimeter-security.tf should be uncommented to allow for the new increase. Please note, the locals.tf file will have updates to uncomment as well. Finally, the protected APIs for this perimeter should be kept up to date with supported APIs. The list is maintained in the locals.tf (there is a link to relevant public documentation as well).