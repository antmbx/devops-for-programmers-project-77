
provider "yandex" {
  zone = "ru-central1-a"
  token = var.yc_token
}



resource "yandex_compute_instance" "default" {
  #name        = "test"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  folder_id   = var.folderID
  #hostname    = var.web_hostname_1  
      
    for_each = var.web-servers
    name = each.value.name
    hostname = each.value.hostname


  resources {
    cores  = 2
    memory = 2
  }

  

  #boot_disk {
  #  disk_id = yandex_compute_disk.default.id
  #}

  boot_disk {
    disk_id = yandex_compute_disk.default[each.key].id
  }


  network_interface {
    subnet_id = var.networkID #"${yandex_vpc_subnet.default.id}"
    nat = each.value.nat
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    #user-data = "${file("./cloud-init.yml")}"
    user-data = <<-EOF
    #!/bin/bash
    echo 'export REDMINE_DB_POSTGRES="${data.yandex_mdb_postgresql_cluster.dbcluster.host.0.fqdn}"' >> .env
    EOF

    
  }


/*
  provisioner "remote-exec" {
  inline = [
<<EOT
sudo docker run -d -p 0.0.0.0:80:3000 \
  -e DB_TYPE=postgres \
  -e DB_NAME=${var.db_name} \
  -e DB_HOST=${yandex_mdb_postgresql_cluster.dbcluster.host.0.fqdn} \
  -e DB_PORT=6432 \
  -e DB_USER=${var.db_user} \
  -e DB_PASS=${var.db_password} \
  ghcr.io/requarks/wiki:2.5
EOT
    ]
  }
*/


}


/*
resource "yandex_vpc_network" "default" {
  folder_id   = var.folderID
}

resource "yandex_vpc_subnet" "default" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["10.5.0.0/24"]
  folder_id   = var.folderID
}
*/


resource "yandex_compute_disk" "default" {

  for_each = var.web-servers
  name     = "${each.key}"
  type     = "network-ssd"
  zone     = "ru-central1-a"
  image_id = "fd83s8u085j3mq231ago" 
  folder_id   = var.folderID
  size = 10 
  labels = {
    environment = "test"
  }
}