locals {
  workflow_template = {
    component_versions = {
      file_system_driver    = "v0.0.0"
      volume_manager        = "v0.0.0"
      snapshot_handler      = "v0.0.0"
    }
    cluster_identifier     = var.gke_cluster_name
    image_repository       = "${var.gcp_region}-docker.pkg.dev/${var.gcp_project_id}/org-${var.dataplane_id}-images"
    instance_id            = var.app_name
    instance_long_id       = var.dataplane_id
    zones_list             = ["alpha", "beta"]
    status_check_url       = "https://${var.gcp_region}-${var.gcp_project_id}.cloudfunctions.net/org-${var.dataplane_id}-fn-check-status"
    k8s_release            = "0.00.0-gke.0000000"
    image_versions = {
      tls_handler_version           = "v0.0.0"
      cert_injector_version         = "v0.0.0"
      cert_controller_version       = "v0.0.0"
      webhook_version               = "v0.0.0"
      main_controller_version       = "rel-0.0.0-00000000-000000"
      ui_internal_version           = "ui-0.0.0-0000000000"
      ui_external_version           = "ui-0.0.0-0000000000"
      disk_attacher_version         = "v0.0.0"
      node_agent_version            = "v0.0.0"
      disk_provisioner_version      = "v0.0.0"
      deploy_controller_version     = "rel-0.0.0-00000000-000000"
      worker_agent_version          = "rel-0.0.0-00000000-000000"
      scale_manager_version         = "rel-0.0.0-00000000-000000"
      auth_proxy_version            = "v0.0"
      liveness_checker_version      = "v0.00.0"
      volume_driver_version         = "rel-0.0.0-00000000-000000"
      state_manager_version         = "rel-0.0.0-00000000-000000"
      connectivity_handler_version  = "rel-0.0.0-00000000-000000"
      termination_handler_version   = "rel-0.0.0-00000000-000000"
      job_scheduler_version         = "rel-0.0.0-00000000-000000"
      gateway_service_version       = "rel-0.0.0-00000000-000000"
      policy_manager_version        = "v0.00.0"
      foundation_image_version      = "00000000-base0.0"
      settings_updater_version      = "rel-0.0.0-00000000-000000"
    }
    setup_service_url      = "https://${var.gcp_region}-${var.gcp_project_id}.cloudfunctions.net/org-${var.dataplane_id}-fn-setup"
    kms_resource           = "projects/${var.gcp_project_id}/locations/${var.gcp_region}/keyRings/ring-${var.gcp_region}/cryptoKeys/key_name"
    gateway_service_url    = "https://${var.gcp_region}-${var.gcp_project_id}.cloudfunctions.net/org-${var.dataplane_id}-fn-gateway"
    resource_tags = {
      owner_id        = var.gcp_project_id
      instance_id     = var.dataplane_id
      location        = var.gcp_region
    }
    availability_zones = [
      "${var.gcp_region}-alpha",
      "${var.gcp_region}-beta"
    ]
    endpoint_subnets = {
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
      "0.0.0.0/00" = ""
    }
    gcp_project            = var.gcp_project_id
    message_queue          = "projects/${var.gcp_project_id}/topics/org-${var.dataplane_id}-queue-messages"
    cloud_region           = var.gcp_region
    notification_url       = "https://${var.gcp_region}-${var.gcp_project_id}.cloudfunctions.net/org-${var.dataplane_id}-fn-notify"
    service_identities = {
      main_controller_identity  = "org-${var.dataplane_id}-controller@${var.gcp_project_id}.iam.gserviceaccount.com"
      worker_node_identity      = "org-${var.dataplane_id}-worker@${var.gcp_project_id}.iam.gserviceaccount.com"
      operator_identity         = "org-${var.dataplane_id}-ops@${var.gcp_project_id}.iam.gserviceaccount.com"
      app_identity              = "org-${var.dataplane_id}-app@${var.gcp_project_id}.iam.gserviceaccount.com"
    }
    resource_metadata = {
      owner_identifier      = var.dataplane_id
      resource_name         = "crn:v0:cloud"
      unique_id             = var.dataplane_id
      offering_type         = "saas-platform"
      geographic_location   = var.gcp_region
      infrastructure        = "gcp"
    }
    service_category = "saas-platform"
    vpc_identifier   = "org-${var.dataplane_id}-vpc"
  }
}

# --- RESOURCES ---

# Trigger the workflow with the dynamic template data
resource "terracurl_request" "trigger_workflow" {
  name   = "trigger_phase2_execution"
  url    = "https://workflowexecutions.googleapis.com/v1/projects/${var.gcp_project_id}/locations/${var.gcp_region}/workflows/${var.workflow_name}/executions"
  method = "POST"
  
  headers = {
    Authorization = "Bearer ${data.google_client_config.current.access_token}"
    Content-Type  = "application/json"
  }

  response_codes = [200, 201]

  # The Workflows API requires 'argument' to be a stringified JSON body
  request_body = jsonencode({
    argument = jsonencode(merge(
      local.workflow_template,
      {
        phase_name = var.phase_name
        env        = var.environment
        retries    = var.retries
      }
    ))
  })

  destroy_url    = "https://httpbin.org/status/200"
  destroy_method = "GET"
  
  lifecycle {
    replace_triggered_by = [terraform_data.always_run]
  }
}

resource "terraform_data" "always_run" {
  input = timestamp()
}

resource "time_sleep" "wait_for_workflow" {
  depends_on      = [terracurl_request.trigger_workflow]
  create_duration = "20s" 
}
