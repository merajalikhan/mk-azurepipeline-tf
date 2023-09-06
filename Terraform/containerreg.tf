resource "azurerm_container_registry" "acr" {
  name                =  "makscr123"#"${var.prefix}acr${lower(random_id.random_number.hex)}"  #"${var.prefix}acr"
  resource_group_name =  "mk-space-game-rg"
  location            =  "UK South" 
  sku                 =  "Standard"
  admin_enabled       =  false
}
