output "data" {
  value = merge(
    module._defaults.data,
    lookup(local.data_map, terraform.workspace)
  )
}
