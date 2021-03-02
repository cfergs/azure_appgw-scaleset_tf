variable "res_grp" {
  description = "The name of the resource group in which the resources will be created"
}

variable "location" {
  description = "The location/region where objects are created. Changing this forces a new resource to be created."
}

variable "tags" {
  description = "tags of objects"
  type        = map(string)
}

variable "vnet_name" {
  description = "Name of VNET"
  default     = "virtualNetwork1"
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = list(string)
}

variable "subnets" {
  description = "List of subnets and prefixes."
  type        = list(object({
    subnet_name   = string
    subnet_prefix = list(string)
  })) 
}
