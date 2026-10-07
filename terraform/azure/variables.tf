variable "project" {
  description = "Nombre corto del proyecto"
  type        = string
}

variable "environment" {
  description = "dev | staging | prod"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment debe ser dev, staging o prod."
  }
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "team" {
  type = string
}

variable "cost_center" {
  type = string
}

variable "owner" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "node_vm_size" {
  default = "Standard_D2s_v3"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "min_nodes" {
  type    = number
  default = 1
}

variable "max_nodes" {
  type    = number
  default = 5
}

variable "budget_amount" {
  description = "Presupuesto mensual USD"
  type        = number
}

variable "budget_start_date" {
  type    = string
  default = "2026-01-01T00:00:00Z"
}

variable "budget_contacts" {
  type    = list(string)
  default = ["finops@corp.io"]
}