################################################################################################
# Resource Group
################################################################################################
resource "azurerm_resource_group" "descomplicando_k8s" {
  name     = "rg-${var.project_name}"
  location = var.location
}

################################################################################################
# Network Resources
################################################################################################
resource "azurerm_virtual_network" "descomplicando_k8s" {
  name                = "vnet-${var.project_name}"
  address_space       = var.vnet_address_spaces
  location            = azurerm_resource_group.descomplicando_k8s.location
  resource_group_name = azurerm_resource_group.descomplicando_k8s.name
}

resource "azurerm_subnet" "descomplicando_k8s" {
  name                 = "sn-${var.project_name}"
  resource_group_name  = azurerm_resource_group.descomplicando_k8s.name
  virtual_network_name = azurerm_virtual_network.descomplicando_k8s.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_public_ip" "descomplicando_k8s" {
  count               = var.vm_count
  name                = "vm-pip-${var.project_name}-${count.index}"
  location            = azurerm_resource_group.descomplicando_k8s.location
  resource_group_name = azurerm_resource_group.descomplicando_k8s.name
  sku                 = var.vm_pip_sku
  allocation_method   = var.vm_pip_allocation_method

}

resource "azurerm_network_interface" "descomplicando_k8s" {
  count               = var.vm_count
  name                = "vm-nic-${var.project_name}-${count.index}"
  location            = azurerm_resource_group.descomplicando_k8s.location
  resource_group_name = azurerm_resource_group.descomplicando_k8s.name

  ip_configuration {
    name                          = var.vm_nic_ip_config_name
    subnet_id                     = azurerm_subnet.descomplicando_k8s.id
    private_ip_address_allocation = var.vm_nic_ip_config_private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.descomplicando_k8s[count.index].id
  }
}

resource "azurerm_network_security_group" "descomplicando_k8s" {
  name                = "nsg-sn-${var.project_name}"
  location            = azurerm_resource_group.descomplicando_k8s.location
  resource_group_name = azurerm_resource_group.descomplicando_k8s.name
}

resource "azurerm_network_security_rule" "allow_ssh_inboud" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = var.subnet_address_prefixes[0]
  resource_group_name         = azurerm_resource_group.descomplicando_k8s.name
  network_security_group_name = azurerm_network_security_group.descomplicando_k8s.name
}

resource "azurerm_network_security_rule" "allow_internet_outbound" {
  name                        = "allow-internet"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = var.subnet_address_prefixes[0]
  resource_group_name         = azurerm_resource_group.descomplicando_k8s.name
  network_security_group_name = azurerm_network_security_group.descomplicando_k8s.name
}

resource "azurerm_subnet_network_security_group_association" "descomplicando_k8s" {
  subnet_id                 = azurerm_subnet.descomplicando_k8s.id
  network_security_group_id = azurerm_network_security_group.descomplicando_k8s.id
}

################################################################################################
# Virtual Machine
################################################################################################
resource "azurerm_linux_virtual_machine" "descomplicando_k8s" {
  count                 = var.vm_count
  name                  = "vm-${var.project_name}-${count.index}"
  resource_group_name   = azurerm_resource_group.descomplicando_k8s.name
  location              = azurerm_resource_group.descomplicando_k8s.location
  size                  = var.vm_size
  admin_username        = var.vm_admin_username
  network_interface_ids = [azurerm_network_interface.descomplicando_k8s[count.index].id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file("~/.ssh/caruso.pub")
  }

  os_disk {
    caching              = var.vm_os_disk_caching
    storage_account_type = var.vm_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.vm_source_image_reference_publisher
    offer     = var.vm_source_image_reference_offer
    sku       = var.vm_source_image_reference_sku
    version   = var.vm_source_image_reference_version
  }
}