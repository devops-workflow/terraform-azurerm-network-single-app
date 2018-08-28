output "vnet_id" {
  description = "The ID of the vNet"
  value       = "${module.network.vnet_id}"
}

output "vnet_name" {
  description = "The Name of the vNet"
  value       = "${module.network.vnet_name}"
}

output "vnet_location" {
  description = "The location of the vNet"
  value       = "${module.network.vnet_location}"
}

output "vnet_address_space" {
  description = "The address space of the vNet"
  value       = "${module.network.vnet_address_space}"
}

output "vnet_subnets" {
  description = "The IDs of subnets in the vNet"
  value       = "${module.network.vnet_subnets}"
}
