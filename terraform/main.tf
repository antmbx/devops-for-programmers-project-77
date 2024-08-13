
variable "yc_token" {}
variable "folderID" {}
variable "web-servers" {}
variable "networkID" {}
variable "subNetworkID" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
variable "ssh_pub" {}

provider "yandex" {
  zone = "ru-central1-a"
  token = var.yc_token
}



resource "yandex_compute_instance" "default" {

  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  folder_id   = var.folderID
 
  for_each = var.web-servers
  name = each.value.name
  hostname = each.value.hostname


  resources {
    cores  = 2
    memory = 2
  }

  


  boot_disk {
    disk_id = yandex_compute_disk.default[each.key].id
  }


  network_interface {
    subnet_id = var.subNetworkID 
    nat = each.value.nat
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_pub}"
    #ssh-keys = "ubuntu:${file("id_rsa.pub")}"
    #user-data = "${file("./cloud-init.yml")}"
    user-data = <<-EOF
    #!/bin/bash
    mkdir /home/ubuntu
    echo 'export REDMINE_DB_POSTGRES="${data.yandex_mdb_postgresql_cluster.dbcluster.host.0.fqdn}"' >> /home/ubuntu/.env
    echo 'export REDMINE_DB_PORT="6432"' >> /home/ubuntu/.env 
    echo 'export REDMINE_DB_DATABASE="${var.db_name}"' >> /home/ubuntu/.env
    echo 'export REDMINE_DB_USERNAME="${var.db_user}"' >> /home/ubuntu/.env
    echo 'export REDMINE_DB_PASSWORD="${var.db_password}"' >> /home/ubuntu/.env
    chmod 0660 /home/ubuntu/.env


    EOF

    
  }
}


resource "yandex_compute_disk" "default" {

  for_each = var.web-servers
  name     = "${each.key}"
  type     = "network-ssd"
  zone     = "ru-central1-a"
  image_id = "fd83s8u085j3mq231ago" 
  folder_id   = var.folderID
  size = 10 
}
