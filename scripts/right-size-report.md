# Informe de Rightsizing (proceso)

## Entradas
- Dashboard FinOps (top 10 recursos por costo del mes).
- Alertas de anomalía.

## Análisis
1. **Utilización**: CPU/memoria promedio de 7 días (Az Monitor / CloudWatch / Cloud Monitoring).
2. **SKU candidata**: la menor que satisface p95 de utilización.
3. **Validar** contra `policies/sku-allowlist.rego` (agregar SKU si aplica, con aprobación FinOps).

## Salida
- Tabla recurso → SKU actual → SKU sugerida → ahorro estimado.
- PR con el cambio en Terraform (el CI hace plan y valida SKU).

## Métrica
`rightsizing_cost_save_mo` = suma del ahorro aplicado en el mes.