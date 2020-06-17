# AKS Azure AD Apps

## Information

This needs to be run before setting up AKS. The service principals are needed for the AKS environment.
You also need to grant admin consent for the server service principal

```
Azure Active Directory > App Registrations > All Applications > sp-<subscribionCommonName>-<environment>-<aksCommonName>-aksserver > API Permissions
Press "Grant Admin Consent for <directory>"
```