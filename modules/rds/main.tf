data "aws_secretsmanager_secret_version" "db" {
  secret_id = var.secret_arn

  depends_on = [var.secret_dependency]
}

locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}

resource "aws_db_subnet_group" "this" {
  name       = "rds-${var.project}-${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.project}-${var.environment}-db-subnet-group"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_db_instance" "this" {
  identifier = "rds-${var.project}-${var.environment}-db"

  engine         = "mysql"
  instance_class = "db.t3.micro"

  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_username
  password = local.db_secret["password"]

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_sg_id]

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

