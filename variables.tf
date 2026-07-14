variable "gcp_project_id" {
  type    = string

}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

# variable "service_account" {
#   type    = string
#   default = "infra-manager-sa@bubbly-pillar-480718-h2.iam.gserviceaccount.com"
# }

variable "workflow_name" {
  type    = string
  #default = "wf-3"
}

variable "phase_name" {
  type        = string
  description = "JSON Input"
  default = "phase-13"
}

variable "environment" {
  type        = string
  description = "prod"
  #default = "prod13"
}

# variable "bucket_name" {
#   type    = string
#   default = "workflow-template-830"
# }

# variable "path" {
#   type    = string
#   default = "./temp.json"
# }

variable "retries" {
  type        = number
  description = "JSON Input"
  #default = "13"
}

#--------------------------------------------------


# ==========================================
#   DEPLOYMENT METADATA VARIABLES
# ==========================================



variable "region" {
  type        = string
  description = "The GCP region where data plane microservices and functions are deployed."
  default = "us-central1"
}

variable "dataplane_id" {
  type        = string
  description = "The unique organization instance or data plane identifier used for naming resources."
  #default = "dp-1"
}

variable "gke_cluster_name" {
  type        = string
  description = "The name of the destination GKE cluster where components are running."
  #default = "ckg-1"
}


# # ==========================================
# #   WORKFLOW EXECUTION VARIABLES
# # ==========================================

 variable "app_name" {
   type        = string
   description = "The name of the target Google Cloud Workflow to execute."
 }

# variable "phase_name" {
#   type        = string
#   description = "The execution phase flag passed as a runtime parameter to the workflow."
#   default = "july14"
# }

# variable "environment" {
#   type        = string
#   description = "The environment classification context (e.g., dev, staging, prod)."
#   default = "dev"
# }

# variable "retries" {
#   type        = number
#   description = "The maximum retry counter assigned to the execution task context."
#   default     = 3
# }
