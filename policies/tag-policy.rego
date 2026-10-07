package finops.tags

# Todos los recursos declarados deben tener los tags obligatorios.
# Se ejecuta con `opafmt` / `opa eval` pasando un inventario de recursos.

required_tags := {"team", "environment", "cost-center", "owner", "repo"}

deny[reason] {
	some resource in input.resources
	missing := required_tags - {tag | some tag in object.keys(resource.tags)}
	count(missing) > 0
	reason := sprintf("%s missing tags: %v", [resource.name, missing])
}