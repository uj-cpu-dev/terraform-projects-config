resource "docker_image" "node_app" {
  name          = "${var.docker_username}/${var.NODE_APP_IMAGE}:latest"
}

resource "docker_image" "react_app" {
  name          = "${var.docker_username}/${var.REACT_APP_IMAGE}:latest"
}

provider "docker" {
  registry_auth {
    address  = "index.docker.io/v1/"
    username = var.docker_username
    password = var.docker_password
  }
}
