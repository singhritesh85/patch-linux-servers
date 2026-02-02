module "azure_arc" {

source = "../module"

prefix = var.prefix
subscription_id = var.subscription_id  
tenant_id = var.tenant_id
resource_group_name = var.resource_group_name
location = var.location[1]

}
