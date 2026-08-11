resource "azurerm_virtual_network" "vnet" {
  name = "vnet-slz"
  address_space = ["10.10.0.0/16"]
  location = azurerm_resource_group.slz.location
  resource_group_name = azurerm_resource_group.slz.name
}

resource "azurerm_subnet" "app" {
    name = "snet-app"
    address_prefixes = [ "10.10.1.0/24" ]
    resource_group_name = azurerm_resource_group.slz.name
    virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "data" {
    name = "snet-data"
    address_prefixes = [ "10.10.2.0/24" ]
    resource_group_name = azurerm_resource_group.slz.name
    virtual_network_name = azurerm_virtual_network.vnet.name
}