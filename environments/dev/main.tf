module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr    = "10.0.0.0/16"
  project     = "3tier-vpc"
  environment = "dev"

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
  environment = "dev"
}

module "security_groups" {
  source = "../../modules/security-groups"

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr

  project     = "3tier-vpc"
  environment = "dev"
}

module "endpoints" {
  source = "../../modules/endpoints"

  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.subnets.app_subnets
  security_group_id = module.security_groups.endpoint_sg_id

  project     = "3tier-vpc"
  environment = "dev"
}

module "alb" {
  source = "../../modules/alb"

  public_subnet_ids = module.subnets.public_subnets
  alb_sg_id         = module.security_groups.alb_sg_id
  vpc_id            = module.vpc.vpc_id

  project     = "3tier-vpc"
  environment = "dev"
}

module "asg" {
  source = "../../modules/asg"

  subnet_ids       = module.subnets.app_subnets
  ec2_sg_id        = module.security_groups.ec2_sg_id
  target_group_arn = module.alb.target_group_arn

  project     = "3tier-vpc"
  environment = "dev"
}

module "rds" {
  source = "../../modules/rds"

  subnet_ids = module.subnets.db_subnets
  rds_sg_id  = module.security_groups.rds_sg_id # temporary (we'll fix later)

  secret_arn        = module.secrets.secret_arn
  secret_dependency = module.secrets

  project     = "3tier-vpc"
  environment = "dev"
}

module "secrets" {
  source = "../../modules/secrets"

  project     = "3tier-vpc"
  environment = "dev"
}