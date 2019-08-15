variable "hcloud_token" {}

provider "hcloud" {
  token = "${var.hcloud_token}"
}

variable "ssh_keys" {
    default = []
}

variable "ssh_user" {
    default = "root"
}

variable "cluster_name" {
    default = "pharos"
}

variable "location" {
    default = "hel1"
}

variable "image" {
    default = "ubuntu-18.04"
}

variable "master_count" {
    default = 1
}

variable "master_type" {
    default = "cx31"
}

variable "worker_count" {
    default = 1
}

variable "worker_type" {
    default = "cx31"
}

resource "hcloud_server" "master" {
    count = "${var.master_count}"
    name = "${var.cluster_name}-master-${count.index}"
    image = "${var.image}"
    server_type = "${var.master_type}"
    ssh_keys = "${var.ssh_keys}"
    location = "${var.location}"
    lifecycle = {
        ignore_changes = [
            "ssh_keys"
        ]
    }
}

resource "random_pet" "worker" {
    count = "${var.worker_count}"
    keepers {
        region = "${var.location}"
    }
}

resource "hcloud_server" "worker" {
    count = "${var.worker_count}"
    name = "${var.cluster_name}-${element(random_pet.worker.*.id, count.index)}"
    image = "${var.image}"
    server_type = "${var.worker_type}"
    ssh_keys = "${var.ssh_keys}"
    location = "${var.location}"
    lifecycle = {
        ignore_changes = [
            "ssh_keys"
        ]
    }
}

output "pharos_hosts" {
  value = {
    masters = {
      address           = "${hcloud_server.master.*.ipv4_address}"
      role              = "master"
      user              = "root"
      container_runtime = "cri-o"

      label = {
        "beta.kubernetes.io/instance-type"         = "${var.worker_type}"
        "failure-domain.beta.kubernetes.io/region" = "${var.location}"
      }
    }

    workers = {
      address           = "${hcloud_server.worker.*.ipv4_address}"
      role              = "worker"
      user              = "root"
      container_runtime = "cri-o"

      label = {
        "beta.kubernetes.io/instance-type"         = "${var.worker_type}"
        "failure-domain.beta.kubernetes.io/region" = "${var.location}"
      }
    }
  }
}