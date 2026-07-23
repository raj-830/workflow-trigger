variable "gcp_project_id" {
  type    = string
  default = "bubbly-pillar-480718-h2"
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

variable "workflow_name" {
  type    = string
  default = "wf-3"
}

variable "destroy_workflow_name" {
  type    = string
  default = "workflow-destroy"
}


variable "phase_name" {
  type        = string
  description = "JSON Input"
  default = "phase-17"
}

variable "environment" {
  type        = string
  description = "prod"
  default = "prod17"
}



variable "retries" {
  type        = number
  description = "JSON Input"
  default = 17
}

#--------------------------------------------------


# ==========================================
#   DEPLOYMENT METADATA VARIABLES
# ==========================================


variable "dataplane_id" {
  type        = string
  description = "The unique organization instance or data plane identifier used for naming resources."
default = "dp-17"
}

variable "gke_cluster_name" {
  type        = string
  description = "The name of the destination GKE cluster where components are running."
  default = "ckg-17"
}


# # ==========================================
# #   WORKFLOW EXECUTION VARIABLES
# # ==========================================

 variable "app_name" {
   type        = string
   description = "The name of the target Google Cloud Workflow to execute."
   default = "wf-app-name"
 }

