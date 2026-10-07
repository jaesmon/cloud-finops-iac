# Cloud FinOps IaC

> Infraestructura como Código **multi-cloud** (Azure, AWS, GCP) con FinOps integrado: tagging obligatorio, presupuestos, derechos de escala (rightsizing) y dashboards de costo — patrones probados en migraciones On-Premise → Multi-Cloud con optimización de costos operativos.

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Terraform](https://img.shields.io/badge/Terraform-1.9-7B42BC)](https://terraform.io)

## Por qué FinOps desde IaC

El costo se decide cuando se **declara** la infraestructura, no cuando llega la factura. Si el IaC no nace con presupuestos, tags y rightsizing, cada recurso es dinero sin gobierno.

```mermaid
flowchart LR
    subgraph IaC (declarativo)
        T[Tagging<br/>obligatorio] --> P[Presupuestos<br/>Budget · alerts]
        P --> R[Rightsizing<br/>SKU + autoscaling]
        R --> A[Alerts<br/>cost anomalías]
    end
    A --> D[(Dashboards<br/>Grafana / Billing)]
```

## Estructura

```
cloud-finops-iac/
├── terraform/
│   ├── azure/
│   │   ├── main.tf            # AKS + presupuesto (budget) de referencia
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── aws/
│   │   ├── main.tf            # EKS + budget + cost anomaly
│   │   └── variables.tf
│   ├── gcp/
│   │   └── main.tf            # GKE + presupuesto + pubsub alert
│   ├── modules/
│   │   ├── cost-tagging/      # Policy que exige tags
│   │   └── finops-budget/     # Budget + alertas multi-cloud
│   └── environments/
│       └── dev/azure.tfvars
├── policies/
│   ├── tag-policy.rego        # OPA: tags obligatorios
│   └── sku-allowlist.rego     # OPA: SKU permitidos (antifuga de costo)
├── dashboards/
│   ├── grafana-cost.json       # Query de costeo por team/coste
│   └── budget-alerts.md
├── scripts/
│   ├── estimate.ps1            # Estimación de despliegue (mock)
│   └── right-size-report.md
└── .github/workflows/
    └── terraform-plan.yml      # plan en cada PR (sin aplicar)
```

## Quickstart

```bash
cd terraform/azure
terraform init
terraform plan -var-file=../environments/dev/azure.tfvars   # CI lo hace en cada PR
terraform apply
```

Los tres clouds comparten módulos `cost-tagging` y `finops-budget` → **paridad FinOps**.

## Decisiones clave

- **Tagging como contrato**: `team`, `environment`, `cost-center`, `owner`. La política OPA falla si falta.
- **Budget con alertas**: cada entorno tiene presupuesto (dev < staging < prod) y alerta al 80/100%.
- **Rightsizing**: SKU mínima + autoscaling + `cost-anomaly` para detección de fugas.
- **Escala**: un solo terraform para 3 nubes, misma lógica FinOps (ver [docs/architecture.md](docs/architecture.md)).

## Licencia

MIT — ver [LICENSE](LICENSE).