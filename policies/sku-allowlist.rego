package finops.sku

import future.keywords.in

# SKU permitidos por tipo (rightsizing): evita fugas de costo por tamaños
# excesivos. Ampliar bajo revisión del Comité FinOps.

allowed_vm := {
	"azure": {"Standard_D2s_v3", "Standard_D4s_v3"},
	"aws":   {"t3.medium", "t3.large"},
	"gcp":   {"e2-medium", "e2-standard-2"},
}

deny[reason] {
	some resource in input.resources
	provider := resource.provider
	not resource.instance_type in allowed_vm[provider]
	reason := sprintf("%s SKU not allowed: %s", [resource.name, resource.instance_type])
}