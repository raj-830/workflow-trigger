




# Fetch the active OAuth2 access token for authentication
data "google_client_config" "current" {}

# 1. Read the content of the object from the GCS bucket

data "google_storage_bucket_object_content" "gcs_file" {
  name   = "path/to/your/object.txt" # The path inside the bucket
  bucket = "your-gcs-bucket-name"
}

# 2. Save that content to a local file on the disk

resource "local_file" "downloaded_file" {
  content  = data.google_storage_bucket_object_content.gcs_file.content
  filename = "${path.module}/downloaded_object.txt" # Destination path
}

# --- RESOURCES ---




# 1. Trigger the workflow with the dynamic template data
resource "terracurl_request" "trigger_workflow" {
  name   = "trigger_phase2_execution"
  url    = "https://workflowexecutions.googleapis.com/v1/projects/${var.gcp_project_id}/locations/${var.gcp_region}/workflows/${var.workflow_name}/executions"
  method = "POST"
  
  headers = {
    Authorization = "Bearer ${data.google_client_config.current.access_token}"
    Content-Type  = "application/json"
  }

  # Tells terracurl that an HTTP 200 or 201 response indicates a successful trigger
  response_codes = [200, 201]

  # Dynamically parses template.json and injects the variables
  request_body = jsonencode({
    #argument = templatefile("${path.module}/file/template.json", {
    argument = templatefile("${var.path}", {
      phase_name = var.phase_name
      env        = var.environment
      retries    = var.retries
    })
  })

  # FIX: Replaced localhost with a safe public mock endpoint to prevent connection errors on destroy/replace
  destroy_url    = "https://httpbin.org/status/200"
  destroy_method = "GET"
  
  lifecycle {
    # Forces a brand new execution on every single 'terraform apply'
    replace_triggered_by = [terraform_data.always_run]
  }
}

# Calculated resource to force a change on every apply sequence
resource "terraform_data" "always_run" {
  input = timestamp()
}

# 2. Pause Terraform for 20 seconds to allow the 15-second Workflow step to run
resource "time_sleep" "wait_for_workflow" {
  depends_on      = [terracurl_request.trigger_workflow]
  create_duration = "20s" 
}

# 3. Pull the workflow execution status from the Google Cloud API
/*
data "http" "workflow_status" {
  depends_on = [time_sleep.wait_for_workflow]
  url        = "https://workflowexecutions.googleapis.com/v1/${jsondecode(terracurl_request.trigger_workflow.response).name}"
  
  request_headers = {
    Authorization = "Bearer ${data.google_client_config.current.access_token}"
    Content-Type  = "application/json"
  }
} */

# 4. Pipeline Guardian: Fails 'terraform apply' if the workflow state isn't SUCCEEDED
/*
resource "null_resource" "status_check" {
  lifecycle {
    postcondition {
      condition     = jsondecode(data.http.workflow_status.response_body).state == "SUCCEEDED"
      error_message = "The GCP Workflow failed or timed out. Final status: ${jsondecode(data.http.workflow_status.response_body).state}"
    }
  }
} */

# 1. Read the content of the object from the GCS bucket
data "google_storage_bucket_object_content" "gcs_file" {
  name   = "path/to/your/object.txt" # The path inside the bucket
  bucket = "your-gcs-bucket-name"
}

# 2. Save that content to a local file on the disk
resource "local_file" "downloaded_file" {
  content  = data.google_storage_bucket_object_content.gcs_file.content
  filename = "${path.module}/downloaded_object.txt" # Destination path
}
