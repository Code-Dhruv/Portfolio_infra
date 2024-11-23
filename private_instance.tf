module "ec2_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  name = "PrivateServer-portfolio"
  # ami                  = data.aws_ami.ubuntu.id
  ami = local.ami

  instance_type        = local.server_instance_type
  key_name             = local.instance_keypair
#   iam_instance_profile = aws_iam_role.ecs_fargate_ssh_role.name
  #monitoring             = true
#   user_data              = file("templates/user_data.ps1.tpl")
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.private_sg.security_group_id]
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required" 
  }

  tags = {
    Owner       = "Managed by Terraform"
    Environment = "${terraform.workspace}"
  }
  # lifecycle {
  #   ignore_changes = [instance_type]
  # }
}

module "private_sg" {
  source = "terraform-aws-modules/security-group/aws"
#   version = "4.17.2"  # Use the appropriate version you want

  name        = "portfolio-private-server-sg"
  description = "Security Group with SSH, HTTP, and HTTPS ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  
  # Ingress Rules & CIDR Blocks
  ingress_rules = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]  # Allow all IPv4 addresses (0.0.0.0/0) to access the above ports
  
  # Egress Rule - all-all open
  egress_rules = ["all-all"]

  tags = {
    Owner       = "Managed by Terraform"
    Environment = "demo"
  }
}


# resource "aws_eip" "bastion_eip" {
#   depends_on = [module.ec2_public, module.vpc]
#   instance   = module.ec2_public.id
#   tags = {
#     Name        = "bastion_portfolio"
#     Owner       = "Managed by Terraform"
#     Environment = "demo"
#   }
# }

