data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.project}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.project}-${var.environment}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.project}-${var.environment}-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [var.ec2_sg_id]

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  user_data = base64encode(<<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd
        systemctl enable httpd
        systemctl start httpd
        echo "Hello from EC2" > /var/www/html/index.html
        EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.project}-${var.environment}-ec2"
      Project     = var.project
      Environment = var.environment
    }
  }
}

resource "aws_autoscaling_group" "this" {
  desired_capacity = 1
  max_size         = 2
  min_size         = 1

  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.project}-${var.environment}-asg"
    propagate_at_launch = true
  }
}

