output "workflow_execution_id" {
  description = "The dynamic execution path locator allocated by the Google Cloud Workflows API."
  value       = jsondecode(data.http.trigger_workflow.response_body).name
}
