terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3"
    }
  }
}

data aws_ecr_repository repo {
 name = var.ecr_repo_name
}

output registry_uri {
  value = split(data.aws_ecr_repository.repo.repository_url, "/")[0]
}

output repository {
  value = data.aws_ecr_repository.repo
}