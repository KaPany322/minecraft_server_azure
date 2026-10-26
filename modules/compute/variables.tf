variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "subnet_name" { type = string }
variable "subnet_id" { type = string }
variable "public_ip_id" { type = string }
variable "network_security_group_id" { type = string }
variable "public_ip_address_name" { type = string }
variable "vm_name" { type = string }
variable "vm_size" { type = string }
variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}
variable "ssh_key_public" { type = string }
variable "admin_username" { type = string }