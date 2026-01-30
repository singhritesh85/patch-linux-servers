terraform {
 backend "s3" {
   bucket         = "dolo-dempo"
   key            = "state/aws-hybrid-activation/terraform.tfstate"
   region         = "us-east-2"
   encrypt        = true
   use_lockfile   = true   ###dynamodb_table = "terraform-state"
 }
}
