# 00-pre-req-terraform-samples

## Overview

The code contained in this folder "00-pre-req-terraform-samples" is intended to
help provide the code and guidance for configuration that is required prior to
setting up Isolator in Google Cloud. It also includes some code that should be
prepared prior to running Isolator but will need to be executed during Isolator
deployment (Org Node Log Sinks). This code should be pulled out and used in the
appropriate, hopefully pre-existing, pipelines that manage these aspects of
Google Cloud for the host organization.

### billing-account-iam.tf

This code demonstrates the IAM permissions needed for the Isolator Google Cloud
Service Accounts which create Google Cloud projects and thus need billing user
permission.

### inputs.auto.tfvars

This file contains the placeholder to enter inputs for the various Terraform
files.

### isolator-folder-and-folder-iam.tf

This file contains the code to deploy the initial Folder for Isolator either
under the org node or under a Google Cloud folder.It also includes the initial
IAM needed for Isolator to manage IAM.

### org-node-iam.tf

This file includes the necessary IAM for Google Cloud Service Accounts for
Isolator. This includes the permission of Org Policy admin for the 02 pipeline
Service Account. It also includes creation of a custom role for managing HFW
rules necessary for the 05 Service Account.

### org-node-log-sink.tf

This is the one file that technically isn't a pre-req in that it cannot be run
until Isolator is deployed and the target destinations for these log sinks
exist (log bucket & PubSub topic).

### variables.tf

This file defines the variables used by the tf files in this folder

### vpc-sc-scoped-policy.tf

This file creates the Scoped Policy for Access Context Manager and the IAM
assignment for the 02 Service Account to manage VPC SC.