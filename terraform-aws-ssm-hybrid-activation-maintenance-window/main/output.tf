output "ssm_hybrid_activation_details" {
  description = "Details of AWS SSM Hybrid Activation and IAM Role ARN"
  value       = "${module.ssm_hybrid_activation}"
  sensitive   = true
}
