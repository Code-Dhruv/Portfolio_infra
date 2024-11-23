module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  name = "BastionHost-portfolio"
  # ami                  = data.aws_ami.ubuntu.id
  ami = local.ami

  instance_type        = local.bastion_instance_type
  key_name             = local.instance_keypair
#   iam_instance_profile = aws_iam_role.ecs_fargate_ssh_role.name
  #monitoring             = true
#   user_data              = file("templates/user_data.ps1.tpl")
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required" 
  }

  tags = {
    Owner       = "Managed by Terraform"
    Environment = "demo"
  }
  # lifecycle {
  #   ignore_changes = [instance_type]
  # }
}

module "public_bastion_sg" {
  source = "terraform-aws-modules/security-group/aws"
  #version = "4.5.0"  
  version = "4.17.2"

  name        = "portfolio-public-bastion-sg"
  description = "Security Group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags = {
    Owner       = "Managed by Terraform"
    Environment = "demo"
  }
}

resource "aws_eip" "bastion_eip" {
  depends_on = [module.ec2_public, module.vpc]
  instance   = module.ec2_public.id
  tags = {
    Name        = "bastion_portfolio"
    Owner       = "Managed by Terraform"
    Environment = "demo"
  }
}

