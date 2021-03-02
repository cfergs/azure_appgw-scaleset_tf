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

variable "scaleset_sku"  {
  description = "The VM SKU for the scale set such as Standard_F2"
  default     = "Standard_F2"
}

variable "scaleset_instances" {
  description = "The # of VM's in the scaleset"
  default = 2
}

variable "username" {
  description = "Username for VM's. NOTE: Azure wont let you use Administrator as a username"
  default     = "localadmin"
}

variable "password" {
  description = "Password for local administrator login account"
}

variable "scaleset_image_publisher" {
  description = "The name of the publisher of the image that you want to deploy."
  default     = "MicrosoftWindowsServer"
}

variable "scaleset_image_offer" {
  description = "The name of the offer of the image that you want to deploy."
  default     = "WindowsServer"
}

variable "scaleset_image_sku" {
  description = "The sku of the image you want to deploy."
  default     = "2016-Datacenter"
}

variable "scaleset_image_version" {
  description = "The version of the image you want to deploy."
  default     = "latest"
}

variable "subnet" {}

variable "main_storage_acct" {
  description = "name of storage account where scaleset script will reside"
}

variable "scale_name" {default = "scaleset"}
variable "appgw_backend_pool" {}
