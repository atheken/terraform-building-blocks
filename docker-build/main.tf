variable working_dir {
  description = "The directory from which to build a container."
}

variable image_name {
  description = "The container image name."
}

variable tag {
  description = "The container tag."
  default = "latest"
}

variable build_arguments {
  description = "Additional build arguments to be passed to the `docker build` command."
  default  = []
}

locals {
  image = "${var.image_name}:${var.tag}"
}

## This always _attempts_ to build the docker container, we take advantage of docker's layer caching
## and assume this will be fast/skipped most of the time:
data external build_container {
  working_dir = var.working_dir
  program = flatten(concat(["${module.path}/docker_image_build.sh", local.image], list(var.build_arguments...)))
}

output result {
  value = merge( { image : local.image }, data.external.build_container.result)
}