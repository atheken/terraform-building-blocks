variable working_dir {
  description = "The directory from which to build a container."
}

variable image_name {
  description = "The container image name."
}

variable tag {
  description = "The container tag. If the tag is not set, the checksum of the source files will be used."
  default = ""
}

variable architecture {
  default = "x86_64"
}

variable build_arguments {
  description = "Additional build arguments to be passed to the `docker build` command."
  default  = []
}

variable force_build {
  description = "When set to true, forces a rebuild of the image."
  default = false
}

module file_checksums {
  source = "../directory-checksum"
  base_path = var.working_dir
  files = ["./**/*"]
}

data external image_count {
  program = ["${abspath(path.module)}/container_exists.sh", local.image]
}

locals {
  
  //if the tag is set, use it, otherwise, tag based on the file_checksum.
  detected_tag = length(var.tag) > 0 ? var.tag : substr(module.file_checksums.result.checksum, 0, 32)
  image = "${var.image_name}:${local.detected_tag}"
  rebuild_trigger = var.force_build || trim(data.external.image_count.result.matching_images, " \t\n") != "1" ? uuid() : "false"
  default_args = ["${abspath(path.module)}/docker_image_build.sh", local.image, "--platform", var.architecture]
  args = length(var.build_arguments) > 0 ? concat(local.default_args, var.build_arguments) : local.default_args
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