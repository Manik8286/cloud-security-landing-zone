resource "azurerm_resource_group" "slz" {
    name = "rg-secure-landing-zone"
    location = "centralindia"
    tags = {
            project = "secure-landing-zone"
            owner   = "manikandan"
    }
}