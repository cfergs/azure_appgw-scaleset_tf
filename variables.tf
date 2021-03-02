variable "res_grp" {
  description = "The name of the resource group in which the resources will be created"
  default     = "testlab2"
}

variable "location" {
  description = "The location/region where objects are created. Changing this forces a new resource to be created."
  default     = "Australia East"
}

#vmpassword can either be set in file or pulled from azurekeyvault.
variable "vmpassword" {
  description = "Default password to set for the VM's."
  default     = "P@ssw0rd123456"
}

variable "tags"  {
  type        = map
  description = "default tag for the environment"
    
  default = {
    environment = "lab"
  }
}
