variable "aws_region" {
  description = "Regiao AWS para provisionamento"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto (usado nas tags)"
  type        = string
  default     = "devops-na-pratica"
}

variable "instance_type" {
  description = "Tipo da instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "ssh_public_key" {
  description = "Chave publica SSH para acesso a instancia"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitido para acesso SSH"
  type        = string
  default     = "0.0.0.0/0"
}
