output "virtual_network_id" {
  value = azurerm_virtual_network.main.id
}

output "subnet_id" {
  value = azurerm_subnet.internal.id
}

output "public_ip_address" {
  value = azurerm_public_ip.linuxboxpip.ip_address
}

output "public_ip_id" {
  value = azurerm_public_ip.linuxboxpip.id
}

output "network_security_group_id" {
  value = azurerm_network_security_group.defaultnsg.id
}
