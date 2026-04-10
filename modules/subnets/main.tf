resource "aws_subnet" "public" {
  count = 3

  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index + 1)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${var.environment}-public-${count.index + 1}"
    Tier        = "public"
    Project     = var.project
    Environment = var.environment
  }
}
resource "aws_subnet" "app" {
  count = 3

  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + 11)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.project}-${var.environment}-app-${count.index + 1}"
    Tier        = "app"
    Project     = var.project
    Environment = var.environment
  }
}
resource "aws_subnet" "db" {
  count = 3

  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + 21)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.project}-${var.environment}-db-${count.index + 1}"
    Tier        = "db"
    Project     = var.project
    Environment = var.environment
  }
}