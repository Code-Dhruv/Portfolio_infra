terraform {
  backend "s3" {
    profile = "portfolio"
    bucket = "portfolio-bucket-361769588144"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"
  }
}
