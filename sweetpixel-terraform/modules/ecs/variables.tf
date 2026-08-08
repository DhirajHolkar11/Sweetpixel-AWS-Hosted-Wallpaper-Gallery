variable "cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "frontend_image" {
  type = string
}

variable "backend_image" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "frontend_target_group_arn" {
  type = string
}

variable "backend_target_group_arn" {
  type = string
}

variable "ecs_security_group_id" {
  type = string
}



variable "bucket_name" {
  type = string
}

variable "cloudfront_url" {
  type = string
}

variable "s3_url" {
  type = string
}