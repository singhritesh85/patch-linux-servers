##################################### Scan the Linux Servers on every sunday Mid-Night and capture the report to S3 Bucket ##################################

resource "aws_ssm_maintenance_window" "maintenance_window" {
  name     = "${var.prefix}-maintenance-window"
  schedule = "cron(0 0 ? * SUN *)" 
  duration = 3
  cutoff   = 1
}

resource "aws_ssm_maintenance_window_target" "maintenance_window_target" {
  window_id      = aws_ssm_maintenance_window.maintenance_window.id
  name           = "${var.prefix}-maintenance-window-targets"
  resource_type = "INSTANCE"
  targets {
    key    = "tag:Environment"
    values = ["dev", "SSM-Multicloud"]  
  }
}

resource "aws_iam_role" "patch_mw_role" {
  name = "${var.prefix}-patch-maintenancewindow-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ssm.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_mw_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
  role       = aws_iam_role.patch_mw_role.name
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.ssm_log_bucket
  force_destroy = true

  tags = {
    Environment = var.env
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3bucket_encryption" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_object" "s3_directory_placeholder" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "linux-servers-patch-details/"
}

resource "aws_ssm_maintenance_window_task" "run_command_task" {
  window_id = aws_ssm_maintenance_window.maintenance_window.id
  task_type = "RUN_COMMAND"
  task_arn  = "AWS-RunPatchBaseline"
  service_role_arn = aws_iam_role.patch_mw_role.arn
  max_concurrency  = "100%"
  max_errors       = "1"
  priority         = 1   # Tasks with lower numbers run first

  targets {
      key    = "WindowTargetIds"
      values = [aws_ssm_maintenance_window_target.maintenance_window_target.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      output_s3_bucket = aws_s3_bucket.s3_bucket.bucket
      output_s3_key_prefix = basename(aws_s3_object.s3_directory_placeholder.key)
      parameter {
        name   = "RebootOption"
        values = ["RebootIfNeeded"] ### or "NoReboot"
      }
      parameter {
        name   = "Operation"
        values = ["Scan"] ### or "Install"
      }
    }
  }
}
