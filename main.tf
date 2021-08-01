# Create a resource  group
resource "azurerm_resource_group" "rg-lcaetano-wiki" {
  name     = "rg-lcaetano-wiki"
  location = var.location
}

# Create PostgreSQL server
resource "azurerm_postgresql_server" "postgresql-server" {
  name                = var.postgresql-server-name
  location            = azurerm_resource_group.rg-lcaetano-wiki.location
  resource_group_name = azurerm_resource_group.rg-lcaetano-wiki.name

  administrator_login          = var.postgresql-admin-login
  administrator_login_password = var.postgresql-admin-password

  sku_name = var.postgresql-sku-name
  version  = var.postgresql-version

  storage_mb        = var.postgresql-storage
  auto_grow_enabled = true

  backup_retention_days            = 7
  geo_redundant_backup_enabled     = false
  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

data "azurerm_client_config" "current" {
}

# Set Active Directory user or group as the administrator
resource "azurerm_postgresql_active_directory_administrator" "ad_admin" {
  resource_group_name = azurerm_resource_group.rg-lcaetano-wiki.name
  server_name         = azurerm_postgresql_server.postgresql-server.name
  login               = var.ad-login-user
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}

# Create PostgreSQL database
resource "azurerm_postgresql_database" "postgresql-db" {
  name                = var.db-name
  resource_group_name = azurerm_resource_group.rg-lcaetano-wiki.name
  server_name         = azurerm_postgresql_server.postgresql-server.name
  charset             = "utf8"
  collation           = "English_United States.1252"
# wait to create the dependent resource
depends_on = [azurerm_resource_group.rg-lcaetano-wiki]
}

# Be aware to create a restrict firewall rule, not like this
resource "azurerm_postgresql_firewall_rule" "postgresql-fw-rule" {
  name                = var.fw-rule-trick
  resource_group_name = azurerm_resource_group.rg-lcaetano-wiki.name
  server_name         = azurerm_postgresql_server.postgresql-server.name
  start_ip_address    = var.first_ip_address
  end_ip_address      = var.last_ip_address
}

# Create App Service
resource "azurerm_app_service_plan" "tcblcwiki_plan" {
  name                = var.app-service-plan
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-lcaetano-wiki.name
  kind                = "Linux"
  reserved            = true
# wait to create the dependent resource
depends_on = [azurerm_postgresql_database.postgresql-db]

  sku {
    tier     = var.app-service-sku-tier
    size     = var.app-service-sku-size
    capacity = var.app-service-sku-capacity
  }

}

resource "azurerm_app_service" "tcblcwiki_app" {
  name                = "lc-wiki-appservice"
  location            = azurerm_resource_group.rg-lcaetano-wiki.location
  resource_group_name = azurerm_resource_group.rg-lcaetano-wiki.name
  app_service_plan_id = azurerm_app_service_plan.tcblcwiki_plan.id
# wait to create the dependent resource
depends_on = [azurerm_app_service_plan.tcblcwiki_plan]

  site_config {
    linux_fx_version = var.appframework-version
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = var.docker-registry
    "DB_TYPE"                             = var.db-type
    "DB_HOST"                             = var.db-host
    "DB_PORT"                             = var.db-port
    "DB_NAME"                             = var.db-name
    "DB_USER"                             = var.db-user
    "DB_PASS"                             = var.postgresql-admin-password
    "DB_SSL"                              = "true"
  }
}


