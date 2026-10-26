terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.10.0"
    }
  }
}

provider "azurerm" {
  features {}

  # azurerm_storage_container uses Microsoft Entra ID instead of account keys.
  storage_use_azuread = true
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}


module "network" {
  source = "./modules/network"

  location                    = var.location
  resource_group_name         = azurerm_resource_group.example.name
  virtual_network_name        = var.virtual_network_name
  vnet_address_prefix         = var.vnet_address_prefix
  subnet_name                 = var.subnet_name
  subnet_address_prefix       = var.subnet_address_prefix
  network_security_group_name = var.network_security_group_name
  public_ip_address_name      = var.public_ip_address_name
  dns_label                   = var.dns_label
  admin_cidr                  = var.admin_cidr
  is_voicechat                = var.is_voicechat
}

module "compute" {
  source = "./modules/compute"

  location                  = var.location
  resource_group_name       = azurerm_resource_group.example.name
  subnet_name               = var.subnet_name
  subnet_id                 = module.network.subnet_id
  public_ip_id              = module.network.public_ip_id
  network_security_group_id = module.network.network_security_group_id
  public_ip_address_name    = var.public_ip_address_name
  vm_name                   = var.vm_name
  vm_size                   = var.vm_size
  source_image_reference    = var.source_image_reference
  ssh_key_public            = var.ssh_key_public
  admin_username            = var.admin_username
}

module "storage" {
  source = "./modules/storage"

  location                       = var.location
  resource_group_name            = azurerm_resource_group.example.name
  subnet_id                      = module.network.subnet_id
  azurerm_storage_account_name   = var.azurerm_storage_account_name
  azurerm_storage_container_name = var.azurerm_storage_container_name
}

resource "azurerm_role_assignment" "minecraft_storage" {
  scope                = module.storage.azurerm_storage_container_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.compute.principal_id
}
