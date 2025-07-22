variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group in which to deploy"
  type        = string
}

variable "subnets" {
  description = "Map of subnet names and CIDR blocks"
  type        = map(string)
}
