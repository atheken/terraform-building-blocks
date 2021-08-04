data aws_ecr_image image {
  repository_name = split(":", var.ecr_image)[0]
  image_tag = split(":", var.ecr_image)[1]
}

data aws_caller_identity identity {
  
}

data aws_region current_region {
  
}

output url {
  value = "${data.aws_caller_identity.identity.account_id}.dkr.ecr.${data.aws_region.current_region.name}.amazonaws.com/${var.ecr_image}" 
}