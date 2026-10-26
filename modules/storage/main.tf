resource "azurerm_storage_account" "main" {
  name                     = var.azurerm_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false

  network_rules {
    default_action             = "Deny"
    bypass                     = ["None"]
    virtual_network_subnet_ids = [var.subnet_id]
  }
}


resource "azurerm_storage_container" "main" {
  name                  = var.azurerm_storage_container_name
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

