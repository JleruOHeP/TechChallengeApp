resource "azurerm_key_vault" "default" {
  name                        = "${local.applicationName}-kv"
  location                    = azurerm_resource_group.default.location
  resource_group_name         = azurerm_resource_group.default.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "terraform_runner_access" {
  key_vault_id = azurerm_key_vault.default.id

  tenant_id = var.tenant_id
  object_id = var.terraform_service_principal_object_id

  key_permissions = [
    "get", "create", "delete", "list", "update"
  ]

  secret_permissions = [
    "backup", "delete", "get", "list", "purge", "recover", "restore", "set"
  ]

  storage_permissions = [
    "backup", "delete", "deletesas", "get", "getsas", "list", "listsas", "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"
  ]
}

resource "azurerm_key_vault_secret" "sql_password" {
  name         = "psql-admin-password"
  value        = random_string.password.result
  key_vault_id = azurerm_key_vault.default.id

  depends_on = [ azurerm_key_vault_access_policy.terraform_runner_access ]
}