provider "aws" {
  region = "us-east-1"
}

//s3 backet lock file
terraform {
  backend "s3" {
    bucket         = "hayk-terraform-backend"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}

module "vpc_main" {
  source = "./vpc"
}

module "aws_route53" {
  source = "./route53"
  //dnsRecord zone id
  zone_name_id = {
    dns_name = module.ec2_instances.alb_dns_name
    zone_id = module.ec2_instances.alb_zone_id
  }
}

module "ec2_instances" {
  source = "./ec2"
  //Target Group
  alb_tg_vpc_id = module.vpc_main.vpc_id_output
  depends_on = [ module.vpc_main ]
  //ALB
  public_subnet_map = {
    "PubSubnet1" = module.vpc_main.public_subnet_a
    "PubSubnet2" = module.vpc_main.public_subnet_b
  }

  cert_validate_arn = module.aws_route53.certification_arn

  //Security group
  main_vpc_id = module.vpc_main.vpc_id_output

  //ec2 instances
  subnet_id_ec2_instances = [ module.vpc_main.private_a_subnet, module.vpc_main.private_b_subnet, module.vpc_main.public_subnet_a ]
  name_of_instances = [ "Instance1", "Instance2", "Bastion Host" ]
}

//instances are not seting up user_data
//write a terraform script to import certificates