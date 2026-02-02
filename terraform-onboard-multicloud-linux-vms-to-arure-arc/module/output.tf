data "azurerm_client_config" "current" {}

output "client_id" {
  value = azuread_application.azure_arc_onboarding_app_ap.client_id
}

output "client_secret" {
  value     = azuread_service_principal_password.azure_arc_onboarding_sp_password.value
  sensitive = true
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

