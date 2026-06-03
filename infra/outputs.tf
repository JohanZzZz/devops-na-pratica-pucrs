output "instance_public_ip" {
  description = "IP publico da instancia EC2"
  value       = aws_instance.app.public_ip
}

output "instance_public_dns" {
  description = "DNS publico da instancia EC2"
  value       = aws_instance.app.public_dns
}

output "app_url" {
  description = "URL da aplicacao"
  value       = "http://${aws_instance.app.public_ip}:5000"
}

output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.main.id
}

output "security_group_id" {
  description = "ID do Security Group"
  value       = aws_security_group.app.id
}
