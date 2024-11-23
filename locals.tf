locals {
  region = "ap-south-1"
  vpc_name = "portfolio-vpc"
  cidr = "10.0.0.0/16"
  azs              = ["ap-south-1a", "ap-south-1b"]
  public_subnets   = ["10.0.1.0/24","10.0.2.0/24"]
  private_subnets  = ["10.0.3.0/24"]
  ami                   = "ami-0dee22c13ea7a9a67"
  instance_keypair      = "portfolio-key"
  bastion_instance_type = "t2.micro"
  server_instance_type  = "t2.micro"
  instance_count        = 1
}