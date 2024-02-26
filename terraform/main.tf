locals {
  base_apis = [
    "container.googleapis.com",
    "monitoring.googleapis.com",
    "cloudtrace.googleapis.com",
    "cloudprofiler.googleapis.com"
  ]

  cluster_name     = google_container_cluster.my_cluster.name
}

# Enable Google Cloud APIs
module "enable_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.0"

  project_id                  = var.gcp_project_id
  disable_services_on_destroy = false

  # activate_apis is the set of base_apis and the APIs required by user-configured deployment options
  activate_apis = concat(local.base_apis)
}

# Create GKE cluster
resource "google_container_cluster" "my_cluster" {

  name     = var.name
  location = var.region
  deletion_protection = false
  # Enabling autopilot for this cluster
  enable_autopilot = true

  # Setting an empty ip_allocation_policy to allow autopilot cluster to spin up correctly
  ip_allocation_policy {
  }

   

  depends_on = [
    module.enable_google_apis
  ]
}

# Get credentials for cluster
module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform              = "linux"
  additional_components = ["kubectl", "beta"]

  create_cmd_entrypoint = "gcloud"
  create_cmd_body = "container clusters get-credentials ${local.cluster_name} --zone=${var.region} --project=${var.gcp_project_id}"
}

# Apply YAML kubernetes-manifest configurations
resource "null_resource" "apply_deployment" {
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "kubectl apply -f ${var.filepath_manifest}"
  }

  depends_on = [
    module.gcloud
  ]
}


resource "null_resource" "apply_policies" {
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "kubectl apply -f ${var.filepath_policies}"
  }

  depends_on = [
    module.gcloud
  ]
}


# Wait condition for all Pods to be ready before finishing
resource "null_resource" "wait_conditions" {
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = <<-EOT
    kubectl wait --for=condition=AVAILABLE apiservice/v1beta1.metrics.k8s.io --timeout=280s
    kubectl wait --for=condition=ready pods --all --timeout=280s
    EOT
  }

  depends_on = [
    resource.null_resource.apply_deployment
  ]
}




