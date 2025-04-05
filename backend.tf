terraform {
  backend "s3" {
    bucket = "tf-state-files-k8s"
    key    = "dev"
    region = "eu-west-3"
  }
}