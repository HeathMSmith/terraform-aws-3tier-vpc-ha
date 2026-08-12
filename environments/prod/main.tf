module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr    = "10.0.0.0/16"
  project     = "3tier-vpc"
  environment = "prod"

  public_subnet_ids  = module.subnets.public_subnets
  private_subnet_ids = module.subnets.app_subnets

  enable_nat_gateway = false
}

data "aws_availability_zones" "available" {}

module "subnets" {
  source = "../../modules/subnets"

  vpc_id             = module.vpc.vpc_id
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)

  project     = "3tier-vpc"
  environment = "prod"
}

module "security_groups" {
  source = "../../modules/security-groups"

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr

  project     = "3tier-vpc"
  environment = "prod"
}

module "endpoints" {
  source = "../../modules/endpoints"

  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.subnets.app_subnets
  security_group_id = module.security_groups.endpoint_sg_id

  project     = "3tier-vpc"
  environment = "prod"
}

module "acm" {
  source = "../../modules/acm"

  domain_name    = "three-tier.hmsdev.click"
  hosted_zone_id = "Z071256718FCET4BG12S8"

  project     = "3tier-vpc"
  environment = "prod"
}

module "alb" {
  source = "../../modules/alb"

  public_subnet_ids = module.subnets.public_subnets
  alb_sg_id         = module.security_groups.alb_sg_id
  vpc_id            = module.vpc.vpc_id
  certificate_arn   = module.acm.certificate_arn

  project     = "3tier-vpc"
  environment = "prod"
}

module "dns" {
  source = "../../modules/dns"

  domain_name    = "three-tier.hmsdev.click"
  hosted_zone_id = "Z071256718FCET4BG12S8"

  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "asg" {
  source = "../../modules/asg"

  ami_id        = "ami-0132130a791af644b"
  instance_type = "t3.micro"

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  subnet_ids       = module.subnets.app_subnets
  ec2_sg_id        = module.security_groups.ec2_sg_id
  target_group_arn = module.alb.target_group_arn

  project     = "3tier-vpc"
  environment = "prod"
}

module "rds" {
  source = "../../modules/rds"

  subnet_ids = module.subnets.db_subnets
  rds_sg_id  = module.security_groups.rds_sg_id

  db_password = module.secrets.db_password

  project     = "3tier-vpc"
  environment = "prod"
}

module "secrets" {
  source = "../../modules/secrets"

  project                 = "3tier-vpc"
  environment             = "prod"
  recovery_window_in_days = 30
}
