terraform {
  backend "s3" {
    bucket       = "hms-terraform-state-portfolio"
    key          = "3tier-vpc/prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}