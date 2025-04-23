############################################################################
# Default Variables
############################################################################
project_name = "descomplicando-k8s"
location     = "Brazil South"

############################################################################
# Network Variables
############################################################################
vnet_address_spaces     = ["10.10.0.0/16"]
subnet_address_prefixes = ["10.10.1.0/24"]
vm_nic_ip_config_name   = "internal"

############################################################################
# VM Variables
############################################################################
vm_count                            = 3
vm_admin_username                   = "caruso"
vm_source_image_reference_publisher = "Canonical"
vm_source_image_reference_offer     = "0001-com-ubuntu-server-jammy"
vm_source_image_reference_sku       = "22_04-lts"
vm_source_image_reference_version   = "latest"