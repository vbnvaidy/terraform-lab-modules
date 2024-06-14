resource "azurerm_network_interface" "myvmnic" {
  name = "${local.resource_name_prefix}-nic-"
  location            = var.resource_group_location 
  resource_group_name = var.resource_group_name 

  ip_configuration {
    name = "internal"
    subnet_id = var.web_subnet_name 
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name                = "${local.resource_name_prefix}-vm"
  location            = var.resource_group_location 
  resource_group_name = var.resource_group_name
  size                = "Standard_F2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.myvmnic.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

  os_disk {
    name = "osdisk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  #custom_data = filebase64("${path.module}/app/app.sh")
}
