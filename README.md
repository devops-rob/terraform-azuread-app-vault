# Azure AD Application Registration for HashiCorp Vault

This Terraform module creates an application in Azure AD for HashiCorp Vault to use when configuring Azure OIDC authentication and the Azure secrets engine. The application is configured with the correct Graph API permission required to perform these functions. Admin consent will still need to be granted for this permission in default directory.

The permission granted to this application is `GroupMember.Read.All` which is the least privileged access permission required for this function.

## Example usage

```hcl
provider "azuread" {}

module "application" {
  source = "../"
}

output "display_name" {
  value = module.application.application_name
}

output "password" {
  value     = module.application.client_secret
  sensitive = true
}

```