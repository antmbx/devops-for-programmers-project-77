data "yandex_mdb_postgresql_cluster" "dbcluster" {
  name      = yandex_mdb_postgresql_cluster.dbcluster.name
  folder_id = var.folderID


}


data "yandex_compute_instance" "default" {
  name       = var.lb-name
  folder_id  = var.folderID
  depends_on = [yandex_compute_instance.default]
}

output "instance_external_ip" {
  value = data.yandex_compute_instance.default.network_interface.0.nat_ip_address


}