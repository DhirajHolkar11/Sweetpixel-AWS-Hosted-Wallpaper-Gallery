


module "s3" {

  source = "./modules/s3"

  bucket_name = var.bucket_name

}

module "cloudfront" {

  source = "./modules/cloudfront"

  bucket_domain_name = module.s3.bucket_domain_name

}

module "ecr" {

  source = "./modules/ecr"

  frontend_repository_name = var.frontend_repository_name
  backend_repository_name  = var.backend_repository_name

}

module "networking" {

  source = "./modules/networking"

  vpc_cidr             = var.vpc_cidr
  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr

  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
}

module "iam" {

  source = "./modules/iam"

  bucket_arn = module.s3.bucket_arn

}

module "cloudwatch" {

  source = "./modules/cloudwatch"

  log_group_name = var.log_group_name

}

module "ecs" {

  source = "./modules/ecs"

  cluster_name = var.ecs_cluster_name

  execution_role_arn = module.iam.ecs_execution_role_arn

  task_role_arn = module.iam.ecs_task_role_arn

  log_group_name = module.cloudwatch.log_group_name

  aws_region = var.aws_region

  frontend_image = var.frontend_image

  backend_image = var.backend_image

  subnet_ids = [
    module.networking.public_subnet_1_id,
    module.networking.public_subnet_2_id
  ]

  depends_on = [
    module.alb
  ]

  ecs_security_group_id = module.security_group.ecs_security_group_id

  frontend_target_group_arn = module.alb.frontend_target_group_arn

  backend_target_group_arn = module.alb.backend_target_group_arn

  bucket_name = module.s3.bucket_name

  cloudfront_url = "https://${module.cloudfront.cloudfront_domain_name}"

  s3_url = "https://${module.s3.bucket_domain_name}"

}

module "security_group" {

  source = "./modules/security-group"

  vpc_id = module.networking.vpc_id

}

module "alb" {

  source = "./modules/alb"

  vpc_id = module.networking.vpc_id

  public_subnet_1_id = module.networking.public_subnet_1_id

  public_subnet_2_id = module.networking.public_subnet_2_id

  alb_security_group_id = module.security_group.alb_security_group_id

}