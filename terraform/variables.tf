variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to apply this config to"
}

variable "name" {
  type        = string
  description = "Name given to the new GKE cluster"
  default     = "online-boutique"
}

variable "region" {
  type        = string
  description = "Region of the new GKE cluster"
  default     = "us-central1"
}



variable "filepath_manifest" {
  type        = string
  description = "Path to Online Boutique's Kubernetes resources, written using Kustomize"
  default     = "../kubernetes-manifests/"
}

variable "filepath_policies" {
  type        = string
  description = "Path to Online Boutique's Kubernetes resources, written using Kustomize"
  default     = "../network-policies/"

 }