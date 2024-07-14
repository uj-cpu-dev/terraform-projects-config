resource "null_resource" "wait_for_db" {
  provisioner "local-exec" {
    command = "sleep 30" # Wait for 30 seconds
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
