# --- VARIABLES ---
variable "gcp_project_id" {
  type    = string
  #default = "saas-demo-496915"
}

variable "gcp_region" {
  type    = string
  #default = "us-central1"
}

variable "workflow_name" {
  type    = string
  #default = "wf-2"
}

variable "phase_name" {
  type    = string
  description = "JSON Input"
  #default = "2-production"
}

variable "environment" {
  type    = string
  description = "JSON Input"
  #default = "saas-demo"
}

variable "retries" {
  type    = number
  description = "JSON Input"
  #default = 3
}
