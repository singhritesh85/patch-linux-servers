variable "project_name" {
  description = "Provide the project name in GCP Account"
  type = string
}

variable "gcp_region" {
  description = "Provide the GCP Region in which Resources to be created"
  type = list
}

variable "prefix" {
  description = "Provide the prefix used for the project"
  type = string
}

variable "env" {
  type = list
  description = "Provide the Environment for GCP Cloud Instrastructure"
}
