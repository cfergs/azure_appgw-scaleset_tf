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
  description = "Name of storage account to be created. Module can only create 1 account at a time"
}

variable "storage_account_kind" {
  description = "Defines the Kind of account. Valid options are Storage, StorageV2 and BlobStorage. Changing this forces a new resource to be created."
  default     = "Storage"
}

variable "storage_account_tier" {
  description = "Required - Defines the Tier to use for this storage account. Valid options are Standard and Premium. Changing this forces a new resource to be created"
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Required - Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS"
  default     = "LRS"
}

variable "containers" {
  description = "list of containers to be created in storage account"
  type        = list(string)
}

variable "container_access_type" {
  description = "(Optional) The 'interface' for access the container provides. Can be either blob, container or private. Defaults to private."
  default     = "private"
}
