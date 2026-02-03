module "patch_gcp_linux_vm" {

  source = "../module"
  project_name = var.project_name
  prefix = var.prefix
  env = var.env[0]
}
