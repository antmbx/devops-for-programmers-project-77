provider "yandex" {
  zone  = "ru-central1-a"
  token = var.yc_token
}


terraform {


  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"





}

