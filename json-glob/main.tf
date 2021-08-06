locals {
  searched_files = flatten([for v in var.files : sort(fileset(var.base_path, v))])
  loaded_files   = [for v in local.searched_files : jsondecode(file("${var.base_path}/${v}"))]
}

output result {
  value = merge(concat([var.base_object], local.loaded_files)...)
}