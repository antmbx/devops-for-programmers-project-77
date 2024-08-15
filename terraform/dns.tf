resource "yandex_dns_zone" "zone1" {
  name        = "my-private-zone"
  description = "hexlet project dns"
  folder_id = var.folderID
  labels = {
    label1 = "hxlt-label-1"
  }

  zone             = "${var.zone-1}."
  public           = true
}


resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "${var.zone-1-dmn}.${var.zone-1}."
  type    = "A"
  ttl     = 200
  data    = ["${data.yandex_compute_instance.default.network_interface.0.nat_ip_address}"]
}