terraform {
  required_version = ">= 0.12.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

variable "number_of_instances" {
  type    = number
  default = 5
}

locals {
  connectors = [
    for i in range(var.number_of_instances) : {
      name = "connector_${i}"
      port_api = 13000 + (i * 3)
      port_ids = 13001 + (i * 3)
      port_management = 13002 + (i * 3)
    }
  ]
}

resource "local_file" "docker_compose" {
  content = templatefile("${path.root}/docker-compose.yml.tftpl", {
    connectors = local.connectors
  })
  filename = "${path.root}/../docker/docker-compose.load-test.yml"
}
