locals {
  
  searched_files = flatten([ for v in var.files : sort(fileset(var.base_path, v)) ])
  located_files = [for v in local.searched_files : { checksum = filesha512("${trimsuffix(var.base_path, "/")}/${v}"), path = "${trimsuffix(var.base_path, "/")}/${v}"}]
}

output result {
  value = {
    files = local.located_files
    checksum = sha512(join("", [for f in local.located_files : f.checksum ]))
  }
}