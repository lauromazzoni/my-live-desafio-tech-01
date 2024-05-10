module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1" #opitonal - Boa prática especificar o version

  name = var.aws_vpc_name
  cidr = var.aws_vpc_cidr

  azs             = var.aws_vpc_azs
  private_subnets = var.aws_vpc_private_subnets
  public_subnets  = var.aws_vpc_public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  #A mesma tag que foi adicioanada abaixo, também tem que ser adicionada em "tags" logo abaixo.
  #Mas para não sobrescrever as tags já parametrizadas em var.aws_project_tags, faz-se o uso  
  #da função "merge" para adicionar a nova tag

  #tags = var.aws_project_tags # era assim (comentei só para registrar como era antes e como ficou)
  tags = merge(var.aws_project_tags, { "kubernetes.io/cluster/${var.aws_eks_name}" = "shared" })

  #Tem que inserir algumas tags para que o EKS 
  #consiga trabalhar com a VPC
  # O "shared" é porque estamos compartilhado esta VPC com o cluster EKS
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.aws_eks_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.aws_eks_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.aws_eks_name
  cluster_version = var.aws_eks_version

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  subnet_ids                     = module.vpc.private_subnets
  vpc_id                         = module.vpc.vpc_id
  cluster_endpoint_public_access = true #será acessível publicamente

  #Criando o grupo de nodes do EKS
  eks_managed_node_groups = {
    default = {
      min_size       = 2
      max_size       = 4
      desired_size   = 2
      instance_types = var.aws_eks_managed_node_groups_instance_type

      tags = var.aws_project_tags
    }
  }

  tags = var.aws_project_tags
}