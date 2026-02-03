output "patch_deployment_id" {
  description = "The ID of the created patch deployment"
  value       = google_os_config_patch_deployment.gcp_linux_vm_patch.patch_deployment_id
}

output "patch_deployment_name" {
  description = "The full resource name of the patch deployment"
  value       = google_os_config_patch_deployment.gcp_linux_vm_patch.name
}

output "patch_deployment_create_time" {
  description = "The creation timestamp"
  value       = google_os_config_patch_deployment.gcp_linux_vm_patch.create_time
}
