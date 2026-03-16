terraform {
  required_version = ">= 1.6.0"
}

variable "environment" {
  type = string
}

resource "null_resource" "dealflow_ai_engine" {
  triggers = {
    environment = var.environment
  }
}
