############################################################################
# Default Variables
############################################################################
project_name = "descomplicando-k8s"
location     = "Brazil South"

############################################################################
# Network Variables
############################################################################
vnet_address_spaces                            = ["10.10.0.0/16"]
subnet_address_prefixes                        = ["10.10.1.0/24"]
vm_nic_ip_config_name                          = "internal"
vm_nic_ip_config_private_ip_address_allocation = "Dynamic"

############################################################################
# VM Variables
############################################################################
vm_count                            = 3
vm_size                             = "Standard_B2s"
vm_admin_username                   = "caruso"
vm_os_disk_caching                  = "ReadWrite"
vm_os_disk_storage_account_type     = "Standard_LRS"
vm_source_image_reference_publisher = "Canonical"
vm_source_image_reference_offer     = "0001-com-ubuntu-server-jammy"
vm_source_image_reference_sku       = "22_04-lts"
vm_source_image_reference_version   = "latest"