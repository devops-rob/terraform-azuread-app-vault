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
