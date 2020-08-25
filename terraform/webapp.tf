resource "azurerm_app_service_plan" "main" {
  name                = "${var.applicationName}-asp"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  kind                = "Linux"

  sku {
    tier = "PremiumV2"
    size = "P1V2"
  }
}

resource "azurerm_app_service" "main" {
  name                = "${var.applicationName}-appservice"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    app_command_line = ""
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/techchallengeapp:latest"
  }

  app_settings = {
      "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
      "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
      "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"

      "VTT_DBHOST"                      = "${local.applicationName}-psql.postgres.database.azure.com"
      "VTT_DBPASSWORD"                  = random_string.password.result
      "VTT_DBUSER"                      = "serviantechtaskadmin@${local.applicationName}-psql"

      "VTT_LISTENHOST"                  = "0.0.0.0"
      "VTT_LISTENPORT"                  = "80"

      "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
}