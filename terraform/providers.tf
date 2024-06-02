provider "kubernetes" {
  # TODO: make sure this works in Workflows
  config_path    = "~/.kube/config"
  config_context = "wachswork"
}
