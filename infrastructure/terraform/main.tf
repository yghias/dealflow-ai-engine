terraform {
  required_version = ">= 1.6.0"
}

variable "environment" {
  type = string
}

resource "null_resource" "platform" {
  triggers = {
    environment = var.environment
  }
}
