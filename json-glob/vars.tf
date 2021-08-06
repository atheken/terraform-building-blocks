variable files {
  type        = list(string)
  description = "A list of glob patters to load. If the pattern turns up set a files, the results will be sorted lexicographically according to the terraform sort pattern before being loaded."
}

variable base_path {
  description = "The base path from which to load the files"
}

variable base_object {
  description = "A starting object into which additional json objects will be merged."
  default     = {}
}