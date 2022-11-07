module ecr_repo {
  source = "../shared-ecr-repo"
  repository_name = var.name
}

module docker_build {
  source = "../docker-build"
  image_name = var.name
  working_dir = var.working_dir
  architecture = var.architecture
}

module docker_push {
  source = "../push-ecr-image"
  local_image = module.docker_build.result.image
  registry_url = module.ecr_repo.registry_url
  depends_on = [
    module.docker_build
  ]
}

resource aws_cloudwatch_log_group logs {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 7
}

resource aws_iam_role_policy policy {
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : concat([
      {
        Effect : "Allow",
        Action : [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Resource : [
          "*"
        ]
      }],
      [
        {
          Effect : "Allow",
          Action : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource : [
            aws_cloudwatch_log_group.logs.arn,
            "${aws_cloudwatch_log_group.logs.arn}/*"
          ]
        }], var.additional_permissions)
  })
  role        = aws_iam_role.role.id
  name_prefix = var.name
}

resource aws_iam_role role {
  name_prefix = var.name
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole"
        Principal : {
          Service : "lambda.amazonaws.com"
        },
        Effect : "Allow"
      }
    ]
  })
}

resource aws_iam_role_policy_attachment basic_execution {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.role.id
  depends_on = [
    aws_iam_role.role
  ]
}

locals {
  env = length(var.env_vars) > 0 ? [var.env_vars] : [] 
}

resource aws_lambda_function scheduled_lambda {
  function_name                  = var.name
  image_config {
    command = var.command
  }
  timeout                        = var.timeout
  role                           = aws_iam_role.role.arn
  image_uri                      = module.docker_push.image_url
  package_type                   = "Image"
  publish                        = true
  reserved_concurrent_executions = var.execution_concurrency
  memory_size                    = var.memory_size
  architectures = [var.architecture]
  
  dynamic environment {
    for_each = local.env
    content {
      variables = environment
    }
  }

  vpc_config {
    security_group_ids = var.security_groups
    subnet_ids         = var.subnets
  }

  depends_on = [
    aws_iam_role.role,
    module.docker_push
  ]
}

resource aws_lambda_permission event_execution {
  for_each      = toset(var.invokers)
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduled_lambda.function_name
  principal     = each.value
}

resource aws_cloudwatch_event_rule schedule {
  for_each            = toset(var.cron_schedules)
  schedule_expression = each.value
  name_prefix         = "${var.name}_"
}

resource aws_cloudwatch_event_target lambda_target {
  for_each = aws_cloudwatch_event_rule.schedule
  arn      = aws_lambda_function.scheduled_lambda.arn
  rule     = each.value.id
}