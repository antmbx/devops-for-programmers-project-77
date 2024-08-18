resource "yandex_mdb_postgresql_cluster" "dbcluster" {
  name        = "tf-cluster-hexlet"
  environment = "PRESTABLE"
  folder_id   = var.folderID
  network_id  = var.networkID

  config {
    version = var.yc_postgresql_version
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 10
    }
    postgresql_config = {
      max_connections = 100
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = var.subNetworkID
  }




}

resource "yandex_mdb_postgresql_user" "dbuser" {
  cluster_id = yandex_mdb_postgresql_cluster.dbcluster.id
  name       = var.db_user
  password   = var.db_password
  depends_on = [yandex_mdb_postgresql_cluster.dbcluster]
}

resource "yandex_mdb_postgresql_database" "db" {
  cluster_id = yandex_mdb_postgresql_cluster.dbcluster.id
  name       = var.db_name
  owner      = yandex_mdb_postgresql_user.dbuser.name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"


  provisioner "local-exec" {
    command = <<-EOT
      (echo $db_fqdn; echo $db_name; echo $db_user; echo $db_password; echo $db_port; echo $datadog_api_key) > ansible/group_vars/webservers/vault.yml
    
      ansible-vault  encrypt ansible/group_vars/webservers/vault.yml --vault-password-file key.secret
   
    EOT  



    working_dir = "../"

    environment = {
      db_fqdn         = "REDMINE_DB_POSTGRES: ${data.yandex_mdb_postgresql_cluster.dbcluster.host.0.fqdn}\n"
      db_name         = "REDMINE_DB_DATABASE: ${var.db_name}\n"
      db_user         = "REDMINE_DB_USERNAME: ${var.db_user}\n"
      db_password     = "REDMINE_DB_PASSWORD: ${var.db_password}\n"
      db_port         = "REDMINE_DB_PORT: 6432\n"
      datadog_api_key = "datadog_api_key: ${var.datadog_api_key}\n"



    }



  }

  depends_on = [yandex_mdb_postgresql_cluster.dbcluster]




}

