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

variable "name" {
  description = "Name of NSG"
}

variable "rules" {
  description = "security rules"
  type        = any
}
