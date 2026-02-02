resource "azurerm_resource_group" "azure_arc" {
  name     = var.resource_group_name
  location = var.location
}

resource "azuread_application" "azure_arc_onboarding_app_ap" {
  display_name = "${var.prefix}-Onboarding-SP"
}

resource "azuread_service_principal" "azure_arc_onboarding_sp" {
  client_id = azuread_application.azure_arc_onboarding_app_ap.client_id
}

resource "azuread_service_principal_password" "azure_arc_onboarding_sp_password" {
  service_principal_id = azuread_service_principal.azure_arc_onboarding_sp.id
  end_date             = "2076-01-01T00:00:00Z" 
}

resource "azurerm_role_assignment" "arc_onboarding_role" {
  scope                = azurerm_resource_group.azure_arc.id
  role_definition_name = "Azure Connected Machine Onboarding"
  principal_id         = azuread_service_principal.azure_arc_onboarding_sp.object_id
}

#resource "azurerm_role_assignment" "arc_onboarding_contributor_role" {
#  scope                = azurerm_resource_group.azure_arc.id
#  role_definition_name = "Contributor"
#  principal_id         = azuread_service_principal.azure_arc_onboarding_sp.object_id
#}
