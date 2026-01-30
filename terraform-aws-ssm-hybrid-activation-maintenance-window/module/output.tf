output "activation_code" {
  description = "Output AWS SSM Hybrid Activation Code"
  value     = aws_ssm_activation.ssm_hybrid_activation.activation_code
}

output "activation_id" {
  description = "Output AWS SSM Hybrid Activation ID"
  value = aws_ssm_activation.ssm_hybrid_activation.id
}

output "iam_role_arn_for_aws_hybrid_activation" {
  description = "The Amazon Resource Name (ARN) specifying the role"
  value       = aws_iam_role.ssm_hybrid_activation_role.arn
}
