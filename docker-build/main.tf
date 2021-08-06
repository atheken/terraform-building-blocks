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

variable force_build {
  description = "When set to true, forces a rebuild of the image."
  default = false
}

locals {
  image = "${var.image_name}:${var.tag}"
  rebuild_trigger = var.force_build ? uuid() : "false"
  default_args = ["${path.module}/docker_image_build.sh", local.image]
  args = length(var.build_arguments) > 0 ? concat(local.default_args, var.build_arguments) : local.default_args
}

module file_checksums {
  source = "../directory-checksum"
  base_path = var.working_dir
  files = ["./**/*", "./*"]
}

## This always _attempts_ to build the docker container whenever files in the working directory changes:
resource null_resource build_container {
  triggers = {
    file_checksums = module.file_checksums.result.checksum
    rebuild_trigger = local.rebuild_trigger
  }
  
  provisioner local-exec {
    working_dir = var.working_dir
    command = join(" ", local.args)  
  }
}

output result {
  value = { image : local.image }
}