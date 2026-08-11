resource "azurerm_network_security_group" "app_nsg" {
    name = "nsg-app"
    location = azurerm_resource_group.slz.location
    resource_group_name = azurerm_resource_group.slz.name
    security_rule {
        name = "AllowHTTPSInbound"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "443"
        source_address_prefix = "Internet"
        destination_address_prefix = "*"
    }
    security_rule {
        name = "DenyAllInbound"
        priority = 4096
        direction = "Inbound"
        access = "Deny"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}