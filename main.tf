#############################################
# Root main.tf — Deploy full infrastructure
#############################################

module "vpc" {
  source        = "./modules/vpc"
  vpc_cidr      = var.vpc_cidr
  public_cidrs  = var.public_cidrs
  private_cidrs = var.private_cidrs
  azs           = var.azs
  tags          = var.tags
  name          = var.name
}

module "nat_gateway" {
  source                  = "./modules/nat_gateway"
  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  private_route_table_ids = module.vpc.private_route_table_ids
  tags                    = var.tags
  name                    = var.name
}

module "iam" {
  source = "./modules/iam"
  name   = var.name
  tags   = var.tags
}

module "jenkins" {
  source               = "./modules/jenkins_instance"
  ami                  = "ami-053b0d53c279acc90" # ✅ Ubuntu 22.04 LTS (us-east-1)
  instance_type        = var.jenkins_instance_type
  private_subnet_ids   = module.vpc.private_subnet_ids
  iam_instance_profile = module.iam.jenkins_instance_profile
  vpc_id               = module.vpc.vpc_id
  vpc_cidr             = var.vpc_cidr
  tags                 = var.tags
  name                 = var.name
}


module "eks" {
  source              = "./modules/eks"
  cluster_name        = var.name
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
  node_instance_types = var.eks_node_instance_types
  node_desired_size   = var.eks_node_desired
  tags                = var.tags
}
