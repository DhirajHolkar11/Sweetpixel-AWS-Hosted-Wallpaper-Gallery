


output "cloudfront_url" {
  value = module.cloudfront.cloudfront_domain_name
}

output "bucket_name" {
  value = module.s3.bucket_name
}


output "frontend_ecr_repository_url" {
  value = module.ecr.frontend_repository_url
}

output "backend_ecr_repository_url" {
  value = module.ecr.backend_repository_url
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_1_id" {
  value = module.networking.public_subnet_1_id
}

output "public_subnet_2_id" {
  value = module.networking.public_subnet_2_id
}

output "ecs_execution_role_arn" {

  value = module.iam.ecs_execution_role_arn

}

output "ecs_task_role_arn" {

  value = module.iam.ecs_task_role_arn

}

output "log_group_name" {

  value = module.cloudwatch.log_group_name

}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}

output "alb_security_group_id" {

  value = module.security_group.alb_security_group_id

}

output "ecs_security_group_id" {

  value = module.security_group.ecs_security_group_id

}

output "alb_dns_name" {

  value = module.alb.alb_dns_name

}

output "frontend_target_group_arn" {

  value = module.alb.frontend_target_group_arn

}

output "backend_target_group_arn" {

  value = module.alb.backend_target_group_arn

}