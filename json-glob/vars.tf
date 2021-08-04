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
  default = {}
}