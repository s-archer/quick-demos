
variable location {
  description = "Azure VPC Region"
  type        = string
  default     = "uksouth"
}

variable cidr {
  description = "Azure VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}


variable availabilityZones {
  description = "If you want the VM placed in an Azure Availability Zone, and the Azure region you are deploying to supports it, specify the numbers of the existing Availability Zone you want to use."
  type        = list
  default     = [1]
}

variable f5_instance_type {
  description = "Specifies the size of the virtual machine."
  type        = string
  default     = "Standard_DS3_v2"
}

variable f5_image_name {
  type    = string
  default = "f5-bigip-virtual-edition-25m-best-hourly"
}

variable f5_version {
  type    = string
  default = "15.1.201000"
}

variable f5_product_name {
  type    = string
  default = "f5-big-ip-best"
}

variable storage_account_type {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  default     = "Standard_LRS"
}

variable "prefix" { 
  description = "prefix used for naming objects created in AWS"
  default = "arch-quickdemo-tf-"
}

variable "uk_se_name" {
  description = "UK SE name tag"
  default     = "arch"
}

variable "hostname-f5" { 
  description = "Hostname for the BIG-IP, must be FQDN"
  default = "bigip"
}

variable "f5_username" { 
  description = "big-ip username"
  default = "azureuser"
}


variable "alien_prefix" { 
  description = "alien address space for Virtual servers"
  default = "10.99.0.0/24"
}



