resource "kubernetes_ingress" "buildlyui_ingress" {
  metadata {
    name = "buildlyui-ingress"
  }

  spec {
    backend {
      service_name = "buildlyui"
      service_port = 9000
    }

    rule {
      http {
        path {
          backend {
            service_name = "buildyui"
            service_port = 9000
          }

        #  path = "/app1/*"
        }

        #path {
        #  backend {
        #    service_name = "MyApp2"
        #    service_port = 8080
        #  }
#
#          path = "/app2/*"
#        }
      }
    }

 #   tls {
 #     secret_name = "tls-secret"
 #   }
  }
}