resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = [var.security_group_id]

  private_dns_enabled = true

  tags = {
    Name        = "${var.project}-${var.environment}-ssm-endpoint"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = [var.security_group_id]

  private_dns_enabled = true

  tags = {
    Name        = "${var.project}-${var.environment}-ec2messages-endpoint"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = [var.security_group_id]

  private_dns_enabled = true

  tags = {
    Name        = "${var.project}-${var.environment}-ssmmessages-endpoint"
    Project     = var.project
    Environment = var.environment
  }
}