# Terraform para GCP — GKE con presupuesto y alertas

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  labels = {
    team          = var.team
    environment   = var.environment
    cost_center   = var.cost_center
    owner         = var.owner
    repo          = "cloud-finops-iac"
  }
}

resource "google_container_cluster" "gke" {
  name     = "gke-${var.environment}"
  location = var.region
  initial_node_count = var.node_count
  resource_labels = local.labels

  node_config {
    machine_type = var.instance_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    labels = local.labels
  }

  deletion_protection = false
}

# FinOps: presupuesto del proyecto con alertas
resource "google_billing_budget" "budget" {
  billing_account = var.billing_account
  display_name    = "budget-${var.environment}"

  budget_filter {
    projects = ["projects/${var.project_id}"]
    labels = {
      environment = var.environment
    }
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = var.budget_amount
    }
  }

  threshold_rules {
    threshold_percent = 0.8
  }
  threshold_rules {
    threshold_percent = 1.0
    spend_basis       = "FORECASTED_SPEND"
  }

  budget_notifications {
    pubsub_topic   = var.budget_topic
    schema_version = "1.0"
  }
}