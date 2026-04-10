terraform {
  backend "s3" {
    bucket         = "hms-terraform-state-3tier-vpc" # <-- EXACT name you created
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}