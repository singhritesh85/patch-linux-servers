############################################## Creation for NSG for Azure Linux Server #######################################################

resource "azurerm_network_security_group" "azure_nsg_azure_linux" {
#  count               = var.vm_count_rabbitmq
  name                = "azure-linux-server-nsg"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name

  security_rule {
    name                       = "azure_linux_server_ssh_azure"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.env
  }
}

########################################## Create Public IP and Network Interface for Azure Linux Server #############################################

resource "azurerm_public_ip" "public_ip_httpd" {
  name                = "azure-linux-server-ip"
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  allocation_method   = var.static_dynamic[0]

  sku = "Standard"   ### Basic, For Availability Zone to be Enabled the SKU of Public IP must be Standard
  zones = var.availability_zone

  tags = {
    environment = var.env
  }
}

resource "azurerm_network_interface" "vnet_interface_azure_linux" {
  name                = "azure-linux-server-nic"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name

  ip_configuration {
    name                          = "azure-linux-server-ip-configuration"
    subnet_id                     = azurerm_subnet.aks_subnet.id
    private_ip_address_allocation = var.static_dynamic[1]
    public_ip_address_id = azurerm_public_ip.public_ip_httpd.id
  }

  tags = {
    environment = var.env
  }
}

############################################ Attach NSG to Network Interface for Azure Linux Server #####################################################

resource "azurerm_network_interface_security_group_association" "nsg_nic_azure_linux" {
#  count                     = 3             ###var.vm_count_rabbitmq
  network_interface_id      = azurerm_network_interface.vnet_interface_azure_linux.id
  network_security_group_id = azurerm_network_security_group.azure_nsg_azure_linux.id

}

######################################################## Create Azure VM for Azure Linux Server ##########################################################

resource "azurerm_linux_virtual_machine" "azure_vm_azure_linux" {
  name                  = "Azure-Linux-Server"
  location              = azurerm_resource_group.aks_rg.location
  resource_group_name   = azurerm_resource_group.aks_rg.name
  network_interface_ids = [azurerm_network_interface.vnet_interface_azure_linux.id]
  size                  = var.vm_size
  zone                  = var.availability_zone[0]
  patch_mode            = "AutomaticByPlatform"
  provision_vm_agent    = true
  computer_name  = "Azure-Linux-Server"
  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_data    = filebase64("custom_data_azure_linux.sh")
  disable_password_authentication = false
  bypass_platform_safety_checks_on_user_schedule_enabled = true

  #### Boot Diagnostics is Enable with managed storage account ########
  boot_diagnostics {
    storage_account_uri  = ""
  }

  source_image_reference {
    publisher = "almalinux"      ###"OpenLogic"
    offer     = "almalinux-x86_64"      ###"CentOS"
    sku       = "8-gen2"         ###"7_9-gen2"
    version   = "latest"         ###"latest"
  }
  os_disk {
    name              = "azure-linux-server-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb      = var.disk_size_gb
  }

  tags = {
    environment = var.env
    patch       = "scheduled"
  }

  depends_on = [azurerm_managed_disk.disk_azure_linux]
}

resource "azurerm_managed_disk" "disk_azure_linux" {
  name                 = "azure-linux-server-datadisk"
  location             = azurerm_resource_group.aks_rg.location
  resource_group_name  = azurerm_resource_group.aks_rg.name
  zone                 = var.availability_zone[0]
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.extra_disk_size_gb
}


resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment_azure_linux" {
  managed_disk_id    = azurerm_managed_disk.disk_azure_linux.id
  virtual_machine_id = azurerm_linux_virtual_machine.azure_vm_azure_linux.id
  lun                ="0"
  caching            = "ReadWrite"
}

