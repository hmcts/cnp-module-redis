# Create a resource group for the machine to be created in
resource "azurerm_resource_group" "rg" {
  name     = "Inspec-Azure"
  location = "${var.location}"
}

# Create the virtual network for the machines
resource "azurerm_virtual_network" "vnet" {
  name                = "Inspec-VNet"
  address_space       = ["10.1.1.0/24"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

# Create the subnet
resource "azurerm_subnet" "subnet" {
  name                 = "Inspec-Subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.1.1.0/24"
}

# Create the NIC for the internal machine
# Give the machine a static IP Address
resource "azurerm_network_interface" "nic1" {
  name                = "Inspec-NIC-1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ipConfiguration1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.1.1.10"
  }
}
