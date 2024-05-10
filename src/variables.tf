variable "aws_region" {
  default     = "us-east-1"
  description = "Região utilizada para criar os recursoso da AWS"
  type        = string
}

variable "aws_vpc_name" {
  default     = "live-vpc"
  description = "Nome da VPC"
  type        = string
}

variable "aws_vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR da VPC"
  type        = string
}

variable "aws_vpc_azs" {
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "Zonas de disponibilidade da VPC"
  type        = set(string) #set é uma lista onde os valores não são duplicados
}

variable "aws_vpc_private_subnets" {
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "endereços de subnets privadas da VPC"
  type        = set(string) #set é uma lista onde os valores não são duplicados
}

variable "aws_vpc_public_subnets" {
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "endereços de subnets públicas da VPC"
  type        = set(string) #set é uma lista onde os valores não são duplicados
}

variable "aws_eks_name" {
  default     = "live-eks"
  description = "Nome do cluster"
  type        = string
}

variable "aws_eks_version" {
  default     = "1.29"
  description = "Versão do cluster"
  type        = string
}

variable "aws_eks_managed_node_groups_instance_type" {
  default     = ["t3.small"]
  description = "Tipo de instância do cluster"
  type        = set(string)
}

variable "aws_project_tags" {
  default = {
    Terraform   = "true"
    Environment = "production"
    Project     = "live"
  }
  description = "tags do projeto"
  type        = map(any)
}