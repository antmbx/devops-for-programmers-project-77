data "yandex_mdb_postgresql_cluster" "dbcluster" {
  name = var.yc_postgresql_version
}