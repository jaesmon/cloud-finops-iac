# Módulo: tagging obligatorio (invariante de costo)

variable "mandatory_tags" {
  type    = list(string)
  default = ["team", "environment", "cost-center", "owner", "repo"]
}

locals {
  # Uso: merge(local.cost_tags, var.extra_tags) en cada recurso.
  cost_tags = {
    team        = var.team
    environment = var.environment
    cost-center = var.cost_center
    owner       = var.owner
    repo        = "cloud-finops-iac"
  }
}

variable "team" {
  type = string
}

variable "environment" {
  type = string
}

variable "cost_center" {
  type = string
}

variable "owner" {
  type = string
}