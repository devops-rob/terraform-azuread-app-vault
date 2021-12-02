output "object_id" {
  value     = azuread_application.vault.object_id
  sensitive = true
}

output "application_id" {
  value     = azuread_application.vault.application_id
  sensitive = true
}


output "client_secret" {
  value = azuread_application_password.vault.value
  sensitive = true
}

output "client_secret_id" {
  value = azuread_application_password.vault.id
}

output "application_name" {
  value = azuread_application.vault.display_name
}

output "tenant_id" {
  value = data.azuread_client_config.current.tenant_id
}