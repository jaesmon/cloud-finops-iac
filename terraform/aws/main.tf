# Terraform para AWS — EKS con budget + detección de anomalías

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  tags = {
    Team        = var.team
    Environment = var.environment
    CostCenter  = var.cost_center
    Owner       = var.owner
    Repo        = "cloud-finops-iac"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.15.0"
  name    = "vpc-${var.environment}"
  cidr    = var.vpc_cidr
  azs     = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  tags = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.6"

  cluster_name    = "eks-${var.environment}"
  cluster_version = "1.31"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  tags            = local.tags

  eks_managed_node_groups = {
    default = {
      min_size     = var.min_nodes
      max_size     = var.max_nodes
      desired_size = var.node_count
      instance_types = [var.instance_type]
      tags = local.tags
    }
  }
}

# FinOps: presupuesto mensual
resource "aws_budgets_budget" "monthly" {
  name         = "budget-${var.environment}"
  budget_type  = "COST"
  limit_amount = var.budget_amount
  limit_unit   = "USD"
  time_period_start = var.budget_start_date
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = var.budget_contacts
  }
  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 100
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = var.budget_contacts
  }
  tags = local.tags
}

# FinOps: anomalía de costo
resource "aws_ce_anomaly_monitor" "cost" {
  name         = "cost-anomaly-${var.environment}"
  monitor_type = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}

resource "aws_ce_anomaly_subscription" "alert" {
  name         = "cost-alert-${var.environment}"
  frequency    = "DAILY"
  monitor_arn_list = [aws_ce_anomaly_monitor.cost.arn]

  subscriber {
    type          = "EMAIL"
    address       = var.budget_contacts[0]
  }
}