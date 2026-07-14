# --- OUTPUTS ---

output "workflow_execution_id" {
  description = "The tracking Execution ID generated in GCP"
  value       = jsondecode(terracurl_request.trigger_workflow.response).name
}

# output "workflow_final_state" {
#   description = "The status returned from the API"
#   value       = jsondecode(data.http.workflow_status.response_body).state
# }

# output "workflow_output_payload" {
#   description = "The actual JSON payload returned from the workflow execution steps"
#   value       = jsondecode(data.http.workflow_status.response_body).result
# }