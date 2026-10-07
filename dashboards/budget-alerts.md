# Budgets y alertas — eventos FinOps

| Evento | Canal | Dueño |
|--------|-------|-------|
| 60% presupuesto (prod) | email | Líder de célula |
| 80% presupuesto | email + #finops | Líder de célula |
| 100% | email + #finops + congela deploy | Director de plataforma |
| Anomalía de costo (>2 desviaciones) | email + #finops | FinOps |

## Runbook al cruzar 80%

1. Confirmar el pico en el dashboard (`dashboards/grafana-cost.json`).
2. Identificar recurso (tags `cost-center` / `team`).
3. Aplicar acción: rightsizing, apagado no-prod, spot, o reserva.
4. Registrar el caso en el ledger y proponer cambio al `policies/sku-allowlist.rego`.

## Derecho de escala (rightsizing) — frecuencia

- Revisión mensual de SKU de los top-10 recursos por costo.
- Regla: dev < staging < prod en tamaño y redundancia.
- `scripts/right-size-report.md` documenta el proceso; se automatiza en el CI
  con el análisis de SKU de OPA.