module "ssm_hybrid_activation" {

source = "../module"
prefix = var.prefix
ssm_log_bucket = var.ssm_log_bucket
env = var.env[0]

}
