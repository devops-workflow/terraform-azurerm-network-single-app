module "label_resource" {
  source        = "devops-workflow/label/local"
  version       = "0.1.3"
  environment   = "${var.environment}"
  name          = "${var.location_short}"
  namespace-env = "true"
  namespace-org = "true"
  organization  = "${var.prefix}"
  tags          = "${var.tags}"
}

locals {
  cidr = "10.10.${var.net_octet}.0/24"
}

module "network" {
  source = "github.com/devops-workflow/terraform-azurerm-network"

  #source              = "devops-workflow/network/azurerm"
  #version             = "2.0.1"
  address_space = "${local.cidr}"

  location            = "${var.location}"
  resource_group_name = "${module.label_resource.id}"
  subnet_names        = ["${var.prefix}"]
  subnet_prefixes     = ["${local.cidr}"]
  tags                = "${module.label_resource.tags}"
  vnet_name           = "${module.label_resource.id}"
}

# Dependency issues. This is not reliable as is. Needs 2 runs
#   trys to create NSG before RG is finished being created
#   rewrite without modules. All resources here (define dependencies ?)
#
# Fork network
#   => NSG needs to reference network: output resource group name
#     use for subnet & nsg
#   Need new output ??
# us-west-2-haproxy01-one
resource "azurerm_subnet" "subnet" {
  name                      = "${var.prefix}"
  address_prefix            = "${local.cidr}"
  resource_group_name       = "${module.network.resource_group_name}"
  virtual_network_name      = "${module.label_resource.id}"
  network_security_group_id = "${module.network_security_group.network_security_group_id}"
}

module "network_security_group" {
  source = "github.com/devops-workflow/terraform-azurerm-network-security-group"

  #source              = "devops-workflow/network-security-group/azurerm"
  #version             = "1.1.2"
  location = "${var.location}"

  resource_group_name = "${module.network.resource_group_name}"
  rg_create           = "false"
  security_group_name = "${module.label_resource.id}"
  tags                = "${module.label_resource.tags}"

  predefined_rules = [
    {
      name                  = "SSH"
      priority              = "100"
      source_address_prefix = ["*"]
    },
  ]

  custom_rules = [
    {
      name                  = "haproxy01-one"
      priority              = "1000"
      direction             = "Inbound"
      access                = "Allow"
      protocol              = "tcp"
      description           = "one haproxy"
      source_address_prefix = "x.x.x.x/32"
    },
    {
      name                   = "haproxy02-one"
      priority               = "1001"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "*"
      description            = "one haproxy"
      source_address_prefix  = "x.x.x.x/32"
    },
    {
      name                   = "haproxy-crawler"
      priority               = "1010"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "*"
      description            = "two haproxy"
      source_address_prefix  = "x.x.x.x/32"
    },
  ]
}

/**/

