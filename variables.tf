variable "location" {
  type        = string
  description = "Location for all of the resources"
  default     = "swedencentral"
}

variable "resource_group_name" {
  type        = string
  description = "Name for resource group where all resources will be created"
  default     = "minecraft_server"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the main virtual network"
  default     = "vnet"
}

variable "vnet_address_prefix" {
  type        = string
  description = "Prefix for the main virtual network"
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  type        = string
  description = "Name of the sub network"
  default     = "default"
}

variable "subnet_address_prefix" {
  type        = string
  description = "Prefix for the sub network"
  default     = "10.0.0.0/24"
}

variable "network_security_group_name" {
  type        = string
  description = "Name of the security group"
  default     = "defaultnsg"
}

variable "public_ip_address_name" {
  type        = string
  description = "Name of the resource: public ip address"
  default     = "linuxboxpip"
}

variable "vm_name" {
  type        = string
  description = "Name of the Virtual Machine"
  default     = "minecraftserver"
}

variable "vm_size" {
  type        = string
  description = "Size of the VM"
  default     = "Standard_F4als_v7"
}

variable "source_image_reference" {
  description = "Azure image used to create the virtual machine."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

variable "ssh_key_public" {
  type        = string
  description = "Public SSH key installed for the VM administrator."
}

variable "admin_cidr" {
  type        = string
  description = "Public IPv4 CIDR allowed to connect to SSH, preferably your address with /32."

  validation {
    condition     = can(cidrnetmask(var.admin_cidr))
    error_message = "admin_cidr must be a valid IPv4 CIDR, such as 203.0.113.10/32."
  }
}

variable "dns_label" {
  type        = string
  description = "DNS name for the server"
  default     = "minecrafttaverna"
}

variable "admin_username" {
  type        = string
  description = "Username of admin user"
  default     = "adminuser"
}

variable "is_voicechat" {
  type        = bool
  description = "Will be voice chat on minecraft server?"
  default     = false
}

variable "azurerm_storage_account_name" {
  type        = string
  description = "Name of storage account"
  default     = "storageaccminecraft"
}

variable "azurerm_storage_container_name" {
  type        = string
  description = "Name of storage container"
  default     = "minecraft-artifacts"
}