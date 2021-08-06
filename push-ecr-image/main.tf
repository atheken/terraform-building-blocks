variable registry_url {
  description = "The registry into which the local container should be pushed"
}

variable local_image {
  description = "The local image that should be tagged and pushed."
}

variable publisher_role_arn {
  description = "The role that should be used for logging in to the docker ECR and publishing. If not set, the ambient credentials will be used."
  default = ""
}

variable assume_role_session_name {
  default = "ecr-publish"
}

data external container_checksum {
  program = ["${abspath(path.module)}/container-checksum.sh", var.local_image ]
}

locals {
  assume_role_args = length(var.publisher_role_arn) > 0 ? "${var.publisher_role_arn} ${var.assume_role_session_name}"
}

resource null_resource image_push {
  triggers = {
    image_id = data.external.container_checksum.result.ImageID
  }
  provisioner local-exec {
    command = "${abspath(path.module)}/push-ecr.sh ${var.local_image} ${var.registry_url} ${local.assume_role_args}"
  }
}