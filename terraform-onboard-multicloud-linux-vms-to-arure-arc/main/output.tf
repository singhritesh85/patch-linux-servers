output "client_id_client_secret_tenant_id" {
  description = "Details of Azure Client ID, Azure Client Secret and Azure Tenant ID"
  value       = "${module.azure_arc}"
  sensitive   = true
}
