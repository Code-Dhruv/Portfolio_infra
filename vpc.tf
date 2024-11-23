module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = local.vpc_name
  cidr            = local.cidr
  azs             = local.azs
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
  # database_subnets = local.env.database_subnets
  public_subnet_tags = {
    Owner       = "Managed by Terraform"
    Environment = "demo"
  }
  enable_nat_gateway = true
  single_nat_gateway = true
  # create_database_subnet_route_table = true

  # create_database_subnet_group = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  private_subnet_tags = {
    Owner       = "Managed by Terraform"
    Environment = "demo"
  }
  # database_subnet_tags = {
  #   Owner       = "Managed by Terraform"
  #   Environment = "${terraform.workspace}"
  # }
  vpc_tags = {
    Owner       = "Managed by Terraform"
    Environment = "demo"
  }
  map_public_ip_on_launch = true
  tags = {
    Owner       = "Managed by Terraform"
    Environment = "demo"
  }

  default_security_group_ingress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all traffic from VPC CIDR"
      cidr_blocks = local.cidr
    }
  ]

  default_security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}