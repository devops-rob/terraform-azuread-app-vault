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


  prevent_duplicate_names = true
  sign_in_audience        = "AzureADMyOrg"
  owners                  = var.app_owners

}

resource "azuread_directory_role" "cloud_application_administrator" {
  template_id = "158c047a-c907-4556-b7ef-446551a6b5f7" # Cloud Application Administrator
}

#resource "azuread_directory_role_member" "Cloud_application_administrator" {
#  role_object_id   = azuread_directory_role.cloud_application_administrator.object_id
#  member_object_id = azuread_application.vault.object_id
#}

resource "azuread_application_password" "vault" {
  display_name          = "Vault"
  application_object_id = azuread_application.vault.object_id
}
