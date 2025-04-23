############################################################################
# Default Variables
############################################################################
variable "project_name" {
  type        = string
  description = "Name of this project"
}
variable "location" {
  type        = string
  description = "Location of the Azure resources"
}


############################################################################
# Network Variables
############################################################################
variable "vnet_address_spaces" {
  type        = list(string)
  description = "Azure virtual network address spaces"
}
variable "subnet_address_prefixes" {
  type        = list(string)
  description = "Azure subnet address prefixes"
}
variable "vm_nic_ip_config_name" {
  type        = string
  description = "Azure virtual machine NIC name"
}
variable "vm_nic_ip_config_private_ip_address_allocation" {
  type        = string
  description = "Azure virtual machine private ip address allocation"
  default     = "Dynamic"
}
variable "vm_pip_sku" {
  type        = string
  description = "Azure virtual machine public ip SKU"
  default     = "Basic"
}
variable "vm_pip_allocation_method" {
  type        = string
  description = "Azure virtual machine public ip allocation method"
  default     = "Dynamic"
}


############################################################################
# VM Variables
############################################################################
variable "vm_count" {
  type        = number
  description = "Number of VMs to deploy"
}
variable "vm_size" {
  type        = string
  description = "Azure virtual machine size"
  default     = "Standard_B2s"
}
variable "vm_admin_username" {
  type        = string
  description = "Azure virtual machine admin user"
}
variable "vm_os_disk_caching" {
  type        = string
  description = "Azure virtual machine os disk caching"
  default     = "ReadWrite"
}
variable "vm_os_disk_storage_account_type" {
  type        = string
  description = "Azure virtual machine os disk storage account type"
  default     = "Standard_LRS"
}
variable "vm_source_image_reference_publisher" {
  type        = string
  description = "Azure virtual machine source image publisher"
}
variable "vm_source_image_reference_offer" {
  type        = string
  description = "Azure virtual machine source image offer"
}
variable "vm_source_image_reference_sku" {
  type        = string
  description = "Azure virtual machine source image SKU"
}
variable "vm_source_image_reference_version" {
  type        = string
  description = "Azure virtual machine source image version"
}