# Ansible configuration of AKS cluster setup with Terraform

### Manually run ansible

NOTE: Since we import secrets from KeyVault, it will fail when running manually without the correct variables avaiable.

```bash
cd azure/ansible/configure-aks
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
