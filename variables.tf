variable "environment" {
  description = "Deployment stage/environment name"
  default     = "test"
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = "westus"
}

variable "location_short" {
  description = "Short standardized location name for use in all resource names"
  default     = "usw"
}

variable "net_octet" {
  description = "Third octet of IP address. Used to build address space and subnet CIDR"
  default     = "0"
}

variable "prefix" {
  description = "Prefix for resource names"
  default     = "proxy"
}

variable "tags" {
  description = "The tags to associate with network and subnets"
  type        = "map"
  default     = {}
}
