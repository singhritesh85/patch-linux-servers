############################################################# IAM Role for Hybrid Activation ######################################################

resource "aws_iam_role" "ssm_hybrid_activation_role" {
  name = "${var.prefix}HybridRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_hybrid_activation_role_policy" {
  role       = aws_iam_role.ssm_hybrid_activation_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_directory_service_Access" {
  role       = aws_iam_role.ssm_hybrid_activation_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}
 
######################################################### SSM Hybrid Activation ##################################################################

resource "aws_ssm_activation" "ssm_hybrid_activation" {
  description        = "${var.prefix} Activation for multicloud servers"
  iam_role           = aws_iam_role.ssm_hybrid_activation_role.name
  registration_limit = 5 # Adjust based on the number of machines
  name               = "${var.prefix}-multicloud-server"
#  expiration_date = "2026-02-15T00:00:00Z"   ### default value is 24 hours

  tags = {
    Environment = "${var.prefix}-Multicloud"
  }
}
