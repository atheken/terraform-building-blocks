terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3"
    }
  }
}

variable registry_url {
  description = "The registry into which the local container should be pushed"
}

variable local_image {
  description = "The local image that should be tagged and pushed."
}

data aws_ecr_authorization_token token {

}

data aws_caller_identity identity {

}

data aws_region current_region {

}

data external container_checksum {
  program = ["${abspath(path.module)}/container-checksum.sh", var.local_image ]
}

resource null_resource image_push {
  triggers = {
    image_id = data.external.container_checksum.result.ImageID
  }
  provisioner local-exec {
    command = "${abspath(path.module)}/push-ecr.sh ${var.local_image} ${var.registry_url} ${data.aws_ecr_authorization_token.token.password}"
  }
}

output image_url {
  value = "${data.aws_caller_identity.identity.account_id}.dkr.ecr.${data.aws_region.current_region.name}.amazonaws.com/${var.local_image}"
}