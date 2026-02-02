resource "azurerm_maintenance_configuration" "guest_linux_vms_scheduled_updates" {
  name                = "${var.prefix}-guest-linux-vms-update-schedule"
  resource_group_name = azurerm_resource_group.azure_arc.name
  location            = azurerm_resource_group.azure_arc.location
  scope               = "InGuestPatch"
  in_guest_user_patch_mode = "User"

  window {
    start_date_time = "2026-02-05 00:00"
    expiration_date_time = "2076-02-05 00:00"
    time_zone       = "GMT Standard Time"
    duration        = "03:00"
    recur_every     = "Week" ### or "1Day", "Month"
  }

  install_patches {
    linux {
      classifications_to_include = ["Critical", "Security", "Other"]
      package_names_mask_to_exclude = []
    }
    reboot = "IfRequired"
  }
  
  tags = {
    patch = "scheduled"
  }
}

resource "azurerm_maintenance_assignment_dynamic_scope" "update_manager_dynamic_scope" {
  name                         = "${var.prefix}-dynamic-scope"
  maintenance_configuration_id = azurerm_maintenance_configuration.guest_linux_vms_scheduled_updates.id

  filter {
    locations       = [azurerm_resource_group.azure_arc.location]
    os_types        = ["Linux"]
    resource_groups = [azurerm_resource_group.azure_arc.name, "azure-linux-vm-rg"]
    resource_types  = ["Microsoft.Compute/virtualMachines", "Microsoft.HybridCompute/machines"]
    tag_filter      = "All"
    tags {
      tag    = "patch"
      values = ["scheduled"]
    }
  }
}
