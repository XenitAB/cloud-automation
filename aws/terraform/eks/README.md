# aws-terraform-example

Terraform example to have a short developer loop and pipeline in Azure DevOps (CI/CD).

# Purpose

## Why was this created?

We think Infrastructure as Code should be used by everyone while at the same time being as easy and accessible as possible.
This was created to kick-start individuals, teams and organizations and give them an example of how they can work.

## What can I do with this?

As of writing, we have created two terraform setups. One for the core infrastructure (`tf-core-infra`) and one for EKS (`tf-eks`) - as well as Azure Pipelines YAMLs for each. There's also a boilerplate (`tf-boilerplate` and `.ci/pipeline-tf-boilerplate.yml`) which hopefully makes it easier for more setups.


### Additional information?

Take a look in the `variables` folder for more information. The `common.tfvars` is used by all environments and `env.tfvars` for each specific environment.

Fork this repository, try it out with Azure Pipelines and make it yours. If you do something cool, you can always do a pull request back here.

# Before using

## Create an Azure connection

Go to (in Azure DevOps) Project Settings > Service connections > New service connection > AWS > Name it `aws-<ENV>` (example: `env-dev`).

Enable/disable environments by modifying `env<ENV>Enabled` (example: `envDevEnabled`) from `false` to `true`.

## Create a variable group

Go to (in Azure DevOps) Pipelines > Library and create the variable group `terraform-encryption` with a variable (should be `secret`) named `terraformEncryptionSecret`. Make sure it's not in clear text - it will be used to encrypt and decrypt the terraform plans stored in artifacts.

## Modify .ci/Invoke-PipelineTask.ps1 to reflect your environment:

You may have to modify the s3 bucket etc.

# Setting up

## Run Terraform

### Manual (powershell script)

```
aws configure --profile kubernetes-dev

export AWS_PROFILE="kubernetes-dev"

pwsh .ci/Invoke-PipelineTask.ps1 -tfFolderName tf-core-infra -build
pwsh .ci/Invoke-PipelineTask.ps1 -tfFolderName tf-core-infra -deploy
```

You may have to run `-build` with the additional parameter `-azureDevOps` once to create the s3 bucket for the state.

### Azure DevOps

The recommended way of running it, since all the configuration required is included. Add the service connection and modify the variable variables to reflect your environment, see `.ci/pipeline-tf-infra-core.yml` for an example.

### Configuring Azure AD permissions

Create an IAM user with full permissions to the account and add it as `aws-<ENV>` (example: `aws-dev`) as a service connection.

## Boilerplate

If you want to create a new terraform setup, copy the `tf-boilerplate` folder and `.ci/pipeline-tf-boilerplate.yml` (with your new names). Make sure to update the pipeline yaml where it says boilerplate to your new setup.
