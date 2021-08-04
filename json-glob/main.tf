variable files {
  type = list(object({
    path = string
    required = bool
  }))
  description = "A list of files to load, some can be optional"
}

variable base_path {
  description = "The base path from which to load the files"
}

variable base_object {
  description = "A starting object into which additional json objects will be merged."
}

locals {
  loaded_files = [for v in var.files : jsondecode(v.required ? file("${var.base_path}/${v.path}") : ( fileexists("${var.base_path}/${v.path}") ? file("${var.base_path}/${v.path}") : "{}" ))]
}

output result {
  value = merge(concat([var.base_object], local.loaded_files)...)
}