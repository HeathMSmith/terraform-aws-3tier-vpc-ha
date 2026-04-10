output "endpoint_ids" {
  value = [
    aws_vpc_endpoint.ssm.id,
    aws_vpc_endpoint.ec2messages.id,
    aws_vpc_endpoint.ssmmessages.id
  ]
}