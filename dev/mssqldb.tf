resource "azurerm_mssql_server" "db_server" {
  name                         = "sql-${var.env}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.db_admin
  administrator_login_password = var.db_password

  tags = {
    environment = var.env
  }
}
