output "object_id" {
  value       = azuread_application.vault.object_id
  sensitive   = true
  description = "Object ID of Azure AD application."
}

output "application_id" {
  value       = azuread_application.vault.application_id
  sensitive   = true
  description = "Application (Client) ID of Azure AD application."
}


output "client_secret" {
  value       = azuread_application_password.vault.value
  sensitive   = true
  description = "Client secret of Azure AD application."
}

output "client_secret_id" {
  value       = azuread_application_password.vault.id
  description = "Client secret ID of Azure AD application."
}

output "application_name" {
  value       = azuread_application.vault.display_name
  description = "Display name of Azure AD application."
}

output "tenant_id" {
  value       = data.azuread_client_config.current.tenant_id
  description = "Tenant ID of Azure subscription."
}

output "application_uri" {
  value       = azuread_application.vault.identifier_uris
  description = "Configured Application ID URIs of Azure AD application."
}