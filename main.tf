resource "random_id" "app" {
  byte_length = 4
}

resource "azuread_application" "vault" {
  display_name = "hashicorp-vault-app-${random_id.app.hex}"

  web {
    redirect_uris = [
      "${var.vault_ui_redirect_address}/ui/vault/auth/oidc/oidc/callback",
      "${var.vault_cli_redirect_address}/oidc/callback"
    ]

    implicit_grant {
      id_token_issuance_enabled = true
    }
  }

  api {
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access example on behalf of the signed-in user."
      admin_consent_display_name = "Access example"
      id                         = "98830695-27a2-44f7-8c18-0c3ebc9698f6"
      type                       = "Admin"
      enabled                    = true
      value                      = "administer"
    }
  }

  group_membership_claims = [
    "All"
  ]

  optional_claims {
    access_token {
      name = "groups"
    }

    id_token {
      name = "groups"
    }

    saml2_token {
      name = "groups"
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "98830695-27a2-44f7-8c18-0c3ebc9698f6" # GroupMember.Read.All
      type = "Role"
    }
  }

  identifier_uris = [
    "api://hashicorp-vault-app-${random_id.app.hex}"
  ]

  prevent_duplicate_names = true
  sign_in_audience        = "AzureADMyOrg"
  owners                  = var.app_owners


}

resource "azuread_service_principal" "vault" {
  application_id = azuread_application.vault.application_id
  owners = [data.azuread_client_config.current.object_id]
}

resource "azuread_directory_role" "cloud_application_administrator" {
  template_id = "158c047a-c907-4556-b7ef-446551a6b5f7" # Cloud Application Administrator
}


resource "azurerm_role_definition" "vault_role" {
  name        = "Vault-role"
  scope       = data.azurerm_subscription.primary.id
  description = "This is role for App registrations used for HashiCorp Vault."

  permissions {
    actions     = [
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachineScaleSets/*/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

resource "azurerm_role_assignment" "vault_role" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.vault_role.role_definition_resource_id
  principal_id         = azuread_service_principal.vault.object_id
}

resource "azuread_application_password" "vault" {
  display_name          = "Vault"
  application_object_id = azuread_application.vault.object_id
}
