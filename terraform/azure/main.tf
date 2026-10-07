# Terraform para Azure — AKS con FinOps integrado

terraform {
  required_version = ">= 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  tags = {
    team          = var.team
    environment   = var.environment
    cost-center   = var.cost_center
    owner         = var.owner
    repo          = "cloud-finops-iac"
    managed-by    = "terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.environment}-${var.project}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.environment}-${var.project}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.project}-${var.environment}"
  tags                = local.tags

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size   # rightsizing: siempre la SKU mínima necesaria
    min_count  = var.min_nodes
    max_count  = var.max_nodes
    enable_auto_scaling = true
  }

  identity {
    type = "SystemAssigned"
  }
}

# FinOps: presupuesto con alertas al 80% y 100%
resource "azurerm_consumption_budget_subscription" "budget" {
  name            = "budget-${var.environment}-${var.project}"
  subscription_id = var.subscription_id
  amount          = var.budget_amount

  time_grain = "Monthly"
  time_period {
    start_date = var.budget_start_date
  }

  notification {
    enabled   = true
    operator  = "EqualTo"
    threshold = 100.0
    contact_emails = var.budget_contacts
  }
  notification {
    enabled   = true
    operator  = "GreaterThan"
    threshold = 80.0
    contact_emails = var.budget_contacts
  }
  tags = local.tags
}