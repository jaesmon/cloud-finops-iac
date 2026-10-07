# Estimación de despliegue multi-cloud (mock FinOps)

Convierte un plan Terraform en una estimación de costo y los sustenta en
las SKU aprobadas. Requiere PowerShell 7+. 

```powershell
.\scripts\estimate.ps1 -Cloud azure -Environment dev -Nodes 3
```