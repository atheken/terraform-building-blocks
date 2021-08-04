locals {
  loaded_files = [for v in var.files : jsondecode(v.required ? file("${var.base_path}/${v.path}") : ( fileexists("${var.base_path}/${v.path}") ? file("${var.base_path}/${v.path}") : "{}" ))]
}

output result {
  value = merge(concat([var.base_object], local.loaded_files)...)
}