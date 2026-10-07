# Principios FinOps — receta

## Tagging obligatorio (producto de este repo)

```hcl
# terraform/modules/cost-tagging/main.tf
variable "mandatory_tags" {
  type = list(string)
  default = ["team", "environment", "cost-center", "owner", "repo"]
}

# En cada recurso que lo admita:
service_tags = merge(var.mandatory_tags, local.extra_tags)
```

La política `policies/tag-policy.rego` bloquea el `apply` si falta alguno.

## Presupuestos escalonados

| Entorno | Presupuesto | Alerta |
|---------|-------------|--------|
| dev | 200 USD/mes | 80% y 100% |
| staging | 800 USD/mes | 80% y 100% |
| prod | 5.000 USD/mes | 60%, 80%, 90%, 100% |

## Rightsizing mínimo

- Node pool AKS/EKS/GKE con autoscaler y **SKU mínima** (`Standard_D2s_v3`).
- Fuera de horario: reducir `replicas` a 1 en dev (cron).
- Spot para workloads interrumpibles y evals de IA.

## Anti-fugas

1. Sin tags → assert en CI (OPA) bloquea.
2. Recursos de un solo uso → TTL y limpieza automática.
3. El `ai-gateway` limita tokens/sesiones (rate limit + budget por cliente).