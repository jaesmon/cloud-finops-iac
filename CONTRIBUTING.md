# Contributing

¡Gracias por contribuir a **cloud-finops-iac**! Todas las ideas FinOps y los
patrones multi-cloud de la empresa son bienvenidos.

## Cómo colaborar

1. Fork y branch descriptivo (`feat/rightsizing-aks`, `fix/sku-policy`).
2. Asegúrate de que los cambios conservan la **paridad multi-cloud** (Azure/AWS/GCP).
3. Toda SKU nueva o política modificada requiere pasar `terraform plan` y las reglas OPA.
4. PR dirigido a `main`.
5. Describe en la descripción el impacto de costo esperado (ahorro/delta).

## Registro de cambios

Usamos un CHANGELOG ligero: por favor documenta tu impacto de costo en el
README/`docs` cuando cambies SKU o presupuestos.