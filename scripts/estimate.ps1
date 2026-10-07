param(
    [ValidateSet("azure", "aws", "gcp")] [string]$Cloud = "azure",
    [ValidateSet("dev", "staging", "prod")] [string]$Environment = "dev",
    [int]$Nodes = 1
)

# Tarifas de referencia (USD/hora, valores ilustrativos).
$Rates = @{
    azure = 0.096   # Standard_D2s_v3
    aws   = 0.048   # t3.medium
    gcp   = 0.062   # e2-medium
}

# Presupuestos por entorno (USD/mes).
$Budgets = @{ dev = 200; staging = 800; prod = 5000 }

$monthly = [math]::Round($Rates[$Cloud] * $Nodes * 730, 2)
$budget  = $Budgets[$Environment]
$pct     = [math]::Round($monthly / $budget * 100, 1)

Write-Output "Cloud: $Cloud | Entorno: $Environment | Nodos: $Nodes"
Write-Output "Estimación mensual: $monthly USD (presupuesto $budget USD -> $pct%)"

if ($pct -lt 80) {
    Write-Output "Estado: DENTRO DE PRESUPUESTO (alertas al 80% y 100%)."
} else {
    Write-Warning "Estado: CERCA/ENCIMA DE PRESUPUESTO. Revisa rightsizing."
    exit 1
}