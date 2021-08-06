resource aws_ecr_repository ecr_repo {
  name = var.repository_name
}

variable reader_principal_org_ids {
  description = "The AWS org ids that may access this repo and read images from this ECR. If you want to provide unfettered read access to all sub accounts in your org, provide the org id here."
  default     = []
}

variable untagged_image_retention_in_days {
  description = "If set, an optional retention policy will be set for untagged images to retained for the number of days specified."
  default     = -1
}

resource aws_ecr_repository_policy access_policy {
  count      = length(var.reader_principal_org_ids) > 0 ? 1 : 0
  repository = aws_ecr_repository.ecr_repo.name
  policy = jsonencode({
    Version : "2008-10-17",
    Statement : [
      {
        Sid : "read-access",
        Effect : "Allow",
        Principal : {
          AWS : "*"
        },
        Condition : {
          StringEquals : {
            "aws:PrincipalOrgID" : var.reader_principal_org_ids
          }
        },
        Action : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages"
        ]
      }
    ]
  })
}

resource aws_ecr_lifecycle_policy retention_policy {
  count      = var.untagged_image_retention_in_days >= 0 ? 1 : 0
  repository = aws_ecr_repository.ecr_repo.name
  policy = jsonencode({
    rules : [
      {
        rulePriority : 1,
        description : "Expire images older than ${var.untagged_image_retention_in_days} days",
        selection : {
          tagStatus : "untagged",
          countType : "sinceImagePushed",
          countUnit : "days",
          countNumber : var.untagged_image_retention_in_days
        },
        action : {
          type : "expire"
        }
      }
    ]
  })
}