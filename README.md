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

## License

Licensed under the Apache License, Version 2.0 (the "License").

You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an _"AS IS"_ basis, without WARRANTIES or conditions of any kind, either express or implied.

See the License for the specific language governing permissions and limitations under the License.