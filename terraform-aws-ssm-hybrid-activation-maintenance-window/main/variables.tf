variable "region" {
  type = string
  description = "Provide the AWS Region into which Resources to be created"
}

variable "prefix" {
  description = "Provide the prefix name for AWS Resources to be created"
  type = string
}

variable "ssm_log_bucket" {
  description = "Provide the bucket name which will keep the log for Linux Server Patching using SSM"
  type = string
}  

variable "env" {
  type = list
  description = "Provide the Environment for AWS Resources"
}
