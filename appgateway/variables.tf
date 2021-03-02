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
  description = "Name of Application Gateway"
}

variable "appgw_cookie_affinity" {default = "Disabled"}

#appgw sku variables
variable "appgw_sku_name"       {default = "Standard_v2"}
variable "appgw_sku_tier"       {default = "Standard_v2"}
variable "appgw_sku_capacity"   {default = 2}

variable "subnet" {
  description = "ID of subnet"
}

variable "diagnostics_workspace" {
  description = "id of log analytics workspace"
}
