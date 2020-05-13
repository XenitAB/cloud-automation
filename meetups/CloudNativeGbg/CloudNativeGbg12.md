# vCloudNativeGbg #12 - Chill out evening

Presentation from Simon Gottschlag 2020-05-14 about deploying EKS using Azure DevOps. (Virtual Meetup)

## Information

This demo will show the following:

* Deployment using both Azure DevOps and command line
* Deployment of core infrastructure in AWS using terraform
* Deployment of EKS using terraform
* Configuration of EKS using Ansible
* Configuration of a service in EKS showing the functionality of external-dns and cert-manager

## Demo

Before demo starts, the following should be verified:
* Move kube config: `mv ~/.kube/config ~/.kube/config_bak_$(date +%Y%m%d%H%M%S)`
* Log on to AWS Console
* Log on to Azure DevOps

## Azure DevOps

* Create AWS account
* Creat IAM user with admin permissions
* Create Azure DevOps project
* Add `aws-dev`, `aws-qa` and `aws-prod` as Azure DevOps service connections (using the above IAM user with admin permissions)
* Add AWS profile using the above IAM user: `aws configure --profile xenit-kubernetes-dev`
* Add pipelines but don't run: (from [XenitAB/cloud-automation](https://github.com/XenitAB/cloud-automation) repositoru on GitHub)
  * aws-tf-core-infra: `/aws/terraform/eks/.ci/pipeline-tf-core-infra.yml`
  * aws-tf-eks: `/aws/terraform/eks/.ci/pipeline-tf-eks.yml`
  * aws-configure-aks: `/aws/ansible/configure-eks/.ci/azure-pipelines.yml`
* Run the terraform pipelines:
  * `aws-tf-core-infra`
  * `aws-tf-eks`
* Configure subdomain delegation (`dev.xenit.io`) to Route53
* Run the ansible pipeline:
  * `aws-configure-eks`

## Local deploy

* Clone GitHub repository: `git clone https://github.com/XenitAB/cloud-automation.git`
* Choose AWS account: `export AWS_PROFILE="xenit-kubernetes-dev"`
* Go to terraform folder for aws: `cd aws/terraform/eks`
* Deploy core infrastructure:
  * Build: `pwsh .ci/Invoke-PipelineTask.ps1 -tfFolderName tf-core-infra -build`
  * Deploy: `pwsh .ci/Invoke-PipelineTask.ps1 -tfFolderName tf-core-infra -deploy`
* Deploy EKS:
  * Build: `pwsh .ci/Invoke-PipelineTask.ps1 -tfFolderName tf-eks -build`
  * Deploy: `pwsh .ci/Invoke-PipelineTask.ps1 -tfFolderName tf-eks -deploy`
* Go to the ansible folder for aws: `cd ../../ansible/configure-eks`

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -r requirements.txt
export environmentShort="dev"
export pythonLocation="$(pwd)/.venv/bin/python"
ansible-playbook -i configure-eks/hosts configure-eks/configure-eks.yml -e "environmentShort=${environmentShort}" -e "ansible_python_interpreter=${pythonLocation}" --flush-cache
```

## Local configuration

* Disable aws cli page: `export AWS_PAGER=""`
* Create AWS Account variable: `awsAccount=$(aws sts get-caller-identity | jq -r .Account)`
* Add the kubeconfig cluster as admin role: `aws eks --region eu-north-1 update-kubeconfig --name eks-dev-en1-eks --role-arn arn:aws:iam::${awsAccount}:role/iam-role-eks-admin`
* Deploy hello-kubernetes: `kubectl apply -f examples/hello-k8s.yaml`
* Wait for certificate to be issued: `kubectl get order --watch`
* Visit `hello-k8s.dev.xenit.io` and verify DNS / cert
* Verify backups `kubectl -n velero get backups` and look at the s3 bucket

## Local cleanup

* Go to terraform folder: `cd ../../terraform/eks`
* Clean up s3 bucket for velero
* Clean up dns records in route53 zone
* Clean up EC2 Load Balancers
* Clean up EC2 Network Interfaces
* Destroy EKS: `pwsh .ci/Invoke-PipelineTask.ps1 -tfFolderName tf-eks -destroy`
* Destroy core infrastructure: `pwsh .ci/Invoke-PipelineTask.ps1 -tfFolderName tf-core-infra -destroy`

## Other cleanup

* Remove Azure DevOps pipelines
* Remove Azure DevOps service connections
* Remove AWS account