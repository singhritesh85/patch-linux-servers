terraform {
  backend "gcs" {
    bucket  = "dolo-dempo"
    prefix  = "state/patch-gcp-linux-vm"
  }
}
