# Ansible configuration of cluster setup with Terraform

## How to run

Before you begin, you need to run the `tf-aks-vnet` Terraform setup (which includes `tf-governance` and `tf-core-infra`).

### Azure DevOps configuration

You need to update the variable group `tflab-keyvault-dev`, `tflab-keyvault-qa` and `tflab-keyvault-prod` in `.ci/templates/pipeline.yml` and create a linked variable group to the KeyVault created with `tf-core-infra` and add the secrets `external-dns`, `kubernetes-backup` and if using Datadog manually create `datadog-api-key` with the correct API key from datadog.

You will also need to update the Azure Service Connections in `.ci/templates/pipeline.yml` (`azureSubscription`) to use a service principal with owner or contributor on the subscription.

### Manually use secrets

Create /tmp/tmp-secrets.sh

```bash
#!/bin/bash

export externalDns="<exported from Azure KeyVault>"
export kubernetesBackup="<exported from Azure KeyVault>"
export datadogApiKey="<exported from Azure KeyVault>"
```

```bash
chmod +x /tmp/tmp-secrets.sh
source /tmp/tmp-secrets.sh
```

### Manually run ansible

NOTE: Since we import secrets from KeyVault, it will fail when running manually without the correct variables avaiable.

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -r requirements.txt
az login
export environmentShort="dev"
export pythonLocation="$(pwd)/.venv/bin/python"
ansible-playbook -i configure-aks/hosts configure-aks/configure-aks.yml -e "environmentShort=${environmentShort}" -e "ansible_python_interpreter=${pythonLocation}" --flush-cache
```

To run only with specific tags:

```bash
ansible-playbook -i configure-aks/hosts configure-aks/configure-aks.yml -e "environmentShort=${environmentShort}" -e "ansible_python_interpreter=${pythonLocation}" --flush-cache --tags="common,velero"
```
