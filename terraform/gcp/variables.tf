variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
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

variable "instance_type" {
  type    = string
  default = "e2-medium"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "budget_amount" {
  type    = number
  default = 300
}

variable "billing_account" {
  type = string
}

variable "budget_topic" {
  type = string
}