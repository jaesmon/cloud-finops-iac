# Arquitectura FinOps multi-cloud

## Paridad entre nubes

| Fase | Azure | AWS | GCP |
|------|-------|-----|-----|
| Tag/etiquetas | `azurerm_... tags` | `common_tags` | `labels` |
| Presupuesto | `azurerm_consumption_budget_*` | `aws_budgets_budget` | `google_billing_budget` |
| Anomalías | Cost alerts (Portal) | `aws_ce_anomaly_subscription` | `cost_insights` |
| Dashboards | Azure Cost Mgmt | Cost Explorer | Billing Reports |

Los **módulos** (`terraform/modules/finops-budget`) abstraen estas diferencias
con la misma interfaz: `budget_amount`, `alarms: [80, 100]`, `tags`.

## Principios FinOps (6Cs del framework)

1. **Understand**: costo por recurso y por unidad de negocio (tags).
2. **Quantify**: presupuesto por entorno y reserva de capacidad.
3. **Architect**: right-sizing + autoscaling + spot (donde aplique).
4. **Operate**: detección de fugas (anomaly alerts), apagado de no-prod.
5. **Monitor**: dashboards (Grafana) alimentan decisiones semanales.
6. **Report**: ledger por célula (ver `ai-gateway /admin/costs` para componente IA).

## Flujo de trabajo

```
PR con IaC → terraform plan (CI) → revisión (tags+SKUs via OPA) → apply
                                              ↓
                                  budget/alarms activos por entorno
                                              ↓
                       alerta 80% → revisión → rightsizing / apagado
```

## Componente IA (FinOps para LLM)

El costo de los modelos está en `ai-gateway/config/models.yaml` + ledger
`/admin/costs`. La telemetría de GPU/tokens alimenta el mismo dashboard de
costo por célula — **Infra + IA bajo el mismo gobierno FinOps**.