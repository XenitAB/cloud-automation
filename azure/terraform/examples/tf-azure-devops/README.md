# Terraform for Azure DevOps

## Uploading the PAT

* Create PAT in Azure DevOps (full access)
* Run the below to upload PAT to Azure KeyVault: 

```shell
echo ""
echo "Enter Azure DevOps PAT: "
read -s AZDO_PAT
echo ""
ENVIRONMENT_SHORT="dev"
LOCATION_SHORT="we"
COMMON_NAME="core"
SECRET_NAME="azure-devops-pat"
echo "Adding secret ${SECRET_NAME} to kv-${ENVIRONMENT_SHORT}-${LOCATION_SHORT}-${COMMON_NAME}: "
echo ""
az keyvault secret set --vault-name kv-${ENVIRONMENT_SHORT}-${LOCATION_SHORT}-${COMMON_NAME} --name ${SECRET_NAME} --value "${AZDO_PAT}"
```