variable "prefix" {
  description = "Provide the prefix name for the Azure Resources to be created"
  type = string
}

variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Provide the Tenant ID for Azure Entra ID Directory"
  type = string
}

variable "resource_group_name" {
  description = "The name of the resource group where Arc machines will be managed"
  type        = string
}

variable "location" {
  description = "The Azure region for the resource group"
  type        = list
}
