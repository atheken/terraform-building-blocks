variable name {}

variable architecture {
  default = "x86_64"
}

variable command {
  type = list(string)
  default = []
}

variable working_dir {
  description = "The location of the base image for the scheduled lambda."
}

variable invokers {
  default = ["events.amazonaws.com"]
}

variable cron_schedules {
  description = "Run this at 12:15AM, nightly. See: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html"
  default     = ["cron(15 0 * * ? *)"]
}

variable execution_concurrency {
  default = 1
}

variable additional_permissions {
  description = "IAM Role Policy statements that will be granted during execution."
  default     = []
}

variable security_groups {
  description = "The security groups under which this lambda executes. You may leave this empty if you don't wish to run this in a VPC."
  default = []
}

variable subnets {
  description = "The subnets under which this lambda should execute. You may leave this empty if you don't wish to run this in a VPC."
  default = []
}

variable env_vars {
  default = {}
}

variable timeout {
  default = 120
}

variable memory_size {
  default = 128
}