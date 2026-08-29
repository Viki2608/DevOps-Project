terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.0.0"
    }
  }
}

resource "flux_bootstrap_git" "this" {
  path = "k8s"
}
