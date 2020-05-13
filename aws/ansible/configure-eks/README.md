# Ansible configuration of cluster setup with Terraform

## How to run

Before you begin, you need to run the `tf-eks` Terraform setup.

### Azure DevOps configuration

You need to have service connection (with admin privileges) in Azure named `aws-<ENV>` (example: `aws-dev`)

### Manually run ansible

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -r requirements.txt
aws configure --profile kubernetes-dev
export AWS_PAGER=""
export AWS_PROFILE="kubernetes-dev"
export environmentShort="dev"
export pythonLocation="$(pwd)/.venv/bin/python"
ansible-playbook -i configure-eks/hosts configure-eks/configure-eks.yml -e "environmentShort=${environmentShort}" -e "ansible_python_interpreter=${pythonLocation}" --flush-cache
```

To run only with specific tags:

```bash
ansible-playbook -i configure-eks/hosts configure-eks/configure-eks.yml -e "environmentShort=${environmentShort}" -e "ansible_python_interpreter=${pythonLocation}" --flush-cache --tags="common,velero"
```
