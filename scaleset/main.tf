#Get main storage account key 
data azurerm_storage_account "dsc_storage_key" {
    name                = var.main_storage_acct
    resource_group_name = var.res_grp
}

resource "azurerm_storage_blob" "upload_scalescript" {
  name                   = "scaleset.ps1"
  storage_account_name   = var.main_storage_acct
  storage_container_name = "scripts"
  type                   = "Block"
  source                 = "./scripts/scaleset.ps1"
}

resource "azurerm_windows_virtual_machine_scale_set" "scaleset" {
  depends_on          = [azurerm_storage_blob.upload_scalescript]
  name                = var.scale_name
  location            = var.location
  resource_group_name = var.res_grp
  tags                = var.tags
  sku                 = var.scaleset_sku
  instances           = var.scaleset_instances
  admin_username      = var.username
  admin_password      = var.password

  source_image_reference {
    publisher = var.scaleset_image_publisher
    offer     = var.scaleset_image_offer
    sku       = var.scaleset_image_sku
    version   = var.scaleset_image_version
  }

  os_disk {
    storage_account_type     = "Standard_LRS"
    caching                  = "ReadWrite"
  }

  network_interface {
    name    = "${var.scale_name}-networkprofile"
    primary = true

    /*
    Note: for application_gateway_backend_address_pool_ids refer to last comment in
    https://github.com/terraform-providers/terraform-provider-azurerm/issues/3169
     Also need to upgrade all the scale instances after you apply.
     */
    ip_configuration {
      name                                          = "${var.scale_name}-IPConf"
      primary                                       = true
      subnet_id                                     = var.subnet
      application_gateway_backend_address_pool_ids  = [var.appgw_backend_pool]
    }
  }

  provision_vm_agent 	= true

  extension {
    name                       = "ScalesetInitialConfigurationScript"
    publisher                  = "Microsoft.Compute"
    type                       = "CustomScriptExtension"
    type_handler_version       = "1.8"
    auto_upgrade_minor_version = true
    settings = <<SETTINGS
    {
      "fileUris": [ "https://${var.main_storage_acct}.blob.core.windows.net/scripts/scaleset.ps1" ]
    }
    SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "commandToExecute": "powershell.exe -File ./scaleset.ps1",
    "storageAccountName": "${var.main_storage_acct}",
    "storageAccountKey": "${data.azurerm_storage_account.dsc_storage_key.primary_access_key}"
  }
  PROTECTED_SETTINGS
  }
  
  extension {
    name                       = "HealthExtension"
    publisher                  = "Microsoft.ManagedServices"
    type                       = "ApplicationHealthWindows"
    type_handler_version       = "1.0"
    auto_upgrade_minor_version = true
    settings = <<SETTINGS
    {
      "protocol": "http",
      "port": "80",
      "requestPath": "/"
    }
    SETTINGS
  }
}
