ephemeral "aws_secretsmanager_random_password" "db" {
  password_length            = 32
  exclude_characters         = "\"'`\\/@"
  require_each_included_type = true
}

resource "aws_secretsmanager_secret" "db" {
  name                    = "${var.project}-${var.environment}-db-credentials"
  recovery_window_in_days = var.recovery_window_in_days

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string_wo = jsonencode({
    username = "admin"
    password = ephemeral.aws_secretsmanager_random_password.db.random_password
  })

  secret_string_wo_version = 1
}
