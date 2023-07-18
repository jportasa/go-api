locals {
  labels = merge(var.labels, {
    app = "mysql-server"
    deploymentName = var.name
  })

  selectors = merge(var.selectors, {
    app = "mysql-server"
    deploymentName = var.name
  })
}

resource "random_string" "mysql_root_password" {
  length = 16
  special = false
}

resource "random_string" "mysql_password" {
  length = 16
  special = false
}

resource "kubernetes_namespace" "mysql" {
    metadata {
        name = var.namespace
    }
}

resource "kubernetes_config_map" "mysql_initdb_config" {
  metadata {
    name      = "mysql-initdb-config"
    namespace = var.namespace
  }

  data = {
    "initdb.sql" = "${file("${path.module}/initdb.sql")}"
  }
}

resource "kubernetes_deployment" "mysql" {
  metadata {
    name = "${var.name}-mysql-server"
    namespace = var.namespace
    labels = local.labels
  }

  spec {
    selector {
      match_labels = local.selectors
    }

    template {
      metadata {
        name = "mysql"
        labels = local.labels
      }

      spec {
        volume {
          name = "mysql-initdb"
          config_map {
            name = "mysql-initdb-config"
          }
        }

        container {
          name = "mysql"
          image = "${var.mysql_image_url}:${var.mysql_image_tag}"

          port {
            container_port = 3306
          }

          resources {
            requests = var.mysql_requests
            limits = var.mysql_limits
          }

          volume_mount {
            mount_path = "/docker-entrypoint-initdb.d"
            name = "mysql-initdb"
          }

          env {
            name = "MYSQL_ALLOW_EMPTY_PASSWORD"
            value = "yes"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mysql" {
  metadata {
    name = "${var.name}"
    namespace = var.namespace
  }

  spec {
    port {
      port = 3306
      target_port = 3306
    }

    selector = local.selectors

    type = "ClusterIP"
  }
}
