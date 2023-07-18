terraform {
  required_providers {
    kind = {
      source  = "kyma-incubator/kind"
      version = "0.0.11"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.22.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "kind" {
  # Configuration options
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-prima-cluster"
}
