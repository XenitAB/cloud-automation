# Terraform Examples

## Terraform

* tf-governance
* tf-core
* tf-aks-aad-apps
* tf-aks-global
* tf-aks1

### Terraform requirements

Runtime order:

`tf-governance` -> `tf-core` -> `tf-aks-aad-apps` -> `[manually granting admin approval]` -> `tf-aks-global` -> `tf-aks1`

If you update namespaces in `tf-aks-global`, you need to run it before you can run `tf-aks1` and add them to the AKS cluster.

## Before running

### Subscriptions

Create these subscriptions for the environment:

* Development subscription: `KuberneteService-dev`
* Quality Assurance subscription: `KuberneteService-qa`
* Production subscription: `KuberneteService-prod`

### Azure AD Groups for subscriptions

Create the following Azure AD Groups:

* `az-sub-tflab-all-owner` - Subscription owner for all subscriptions
* `az-sub-tflab-all-contributor` - Subscription contributor for all subscriptions
* `az-sub-tflab-all-reader` - Subscription reader for all subscriptions


### Azure Owner Service Principal

Create and delegate access to the `owner` service principal:

* Create new service principal: `sp-sub-tflab-all-owner`
* Grant service principal the following permissions:
  * API Permissions: (Application)
    * `Group.ReadWrite.All` (`Microsoft Graph`)
    * `Application.ReadWrite.All` (`Azure Active Directory Graph` - it's under the `Supported legacy APIs` section)
  * Subscription permissions on all the subscriptions: `Owner` 
  * The service principal also needs to be member of the `User administrator` role

### Azure DevOps

#### Service connections

Add the service principal three times to Azure DevOps:

* Development service connection name: `azure-tflab-dev-owner` -> `KuberneteService-dev`
* Quality Assurance service connection name: `azure-tflab-qa-owner` -> `KuberneteService-qa`
* Production service connection name: `azure-tflab-prod-owner` -> `KuberneteService-prod`

#### Variable group

Create a variable group named `terraform-encryption` with a *secret* value called `terraformEncryptionSecret` which contains the secret for storing encrypted terraform plans in Azure Pipelines Build Artifact.