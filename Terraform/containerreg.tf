resource "azurerm_container_registry" "acr" {
  name                =  "makscr123"#"${var.prefix}acr${lower(random_id.random_number.hex)}"  #"${var.prefix}acr"
  resource_group_name = 'mk-space-game-rg' #var.rgname #azurerm_resource_group.devopsjourney_resource_group.name
  location            =  'UK South' #var.location #azurerm_resource_group.devopsjourney_resource_group.location
  sku                 = "Standard"
  admin_enabled       = false
