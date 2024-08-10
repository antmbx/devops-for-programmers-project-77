data "yandex_mdb_postgresql_cluster" "dbcluster" {
  name = yandex_mdb_postgresql_cluster.dbcluster.name
  folder_id = var.folderID
}