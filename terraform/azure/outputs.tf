output "aks_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "kubeconfig_command" {
  value = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.aks.name}"
}

output "budget" {
  value = {
    amount = azurerm_consumption_budget_subscription.budget.amount
    name   = azurerm_consumption_budget_subscription.budget.name
  }
}