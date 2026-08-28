module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "rds" {
  source          = "./modules/rds"
  project_name    = "db-${var.project_name}"
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  db_username     = var.db_username
  db_password     = var.db_password
}


# module "ecr" {
#   source       = "./modules/ecr"
#   project_name = var.project_name
#   environment  = var.environment
# }

# module "eks" {
#   source          = "./modules/eks"
#   project_name    = var.project_name
#   environment     = var.environment
#   vpc_id          = module.vpc.vpc_id
#   private_subnets = module.vpc.private_subnet_ids
# }


