provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "${var.environment}"
      Project     = "${var.project}"
      Terraform   = "true"
    }
  }
}