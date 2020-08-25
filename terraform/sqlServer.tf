resource "random_string" "password" {
  length = 16
  special = true
  override_special = "!@#%&*()-_=+[]"
}

resource "azurerm_postgresql_server" "psql_server" {
  name                = "${local.applicationName}-psql"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "serviantechtaskadmin"
  administrator_login_password = random_string.password.result
  version                      = "10"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_firewall_rule" "sql_ffa_rule" {
  name                = "ffa"
  resource_group_name = azurerm_resource_group.default.name
  server_name         = azurerm_postgresql_server.psql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}