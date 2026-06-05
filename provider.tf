terraform {
  required_version = ">= 1.4.0"
  required_providers {
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "~> 1.1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# --- PROVIDERS & DATA ---
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}