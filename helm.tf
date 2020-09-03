/*
# keeping this in so i can see the ingress rules it creates
resource "helm_release" "apache" {
  name       = "apache"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "apache"
}
*/


/*
resource "helm_release" "consul" {
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
}
*/

/*
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
 # depends_on = [module.eks, aws_db_instance.buildlydb]
  depends_on = [module.eks]
}
*/

/*
resource "helm_release" "buildly-core-chart" {
  name  = "buildly-core-chart"
  chart = "helm-charts/buildly-core-chart"
  values = [
    "${file("helm-charts/buildly-core-chart/values.yaml")}"
  ]
  namespace = kubernetes_namespace.buildly.metadata[0].name
#    depends_on = [aws_db_instance.buildlydb]
  #  timeout   = 900
}
*/


#  resource "helm_release" "buildly-ui-chart" {
#  name  = "buildly-ui-chart"
#  #name  = "buildly"
#  chart = "helm-charts/buildly-ui-chart"
#  values = [
#    "${file("helm-charts/buildly-ui-chart/values.yaml")}"
#  ]
#  namespace  = kubernetes_namespace.buildly.metadata[0].name
##  depends_on = [helm_release.nginx-stable]
#  ##  depends_on = [aws_db_instance.buildlydb]
#   # timeout   = 1500
#}

/*
resource "helm_release" "nginx-stable" {
  name       = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
#  chart      = "helm-charts/ingress-nginx"
   values = [
    "${file("values-nginx-ingress.yaml")}"
  ]
#  depends_on = [helm_release.buildly-core-chart]
}
*/

