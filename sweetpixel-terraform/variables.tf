variable "aws_region" {
  description = "AWS Region"

  type = string
}

variable "bucket_name" {
  description = "S3 Bucket Name"

  type = string
}


variable "frontend_repository_name" {
  type = string
}

variable "backend_repository_name" {
  type = string
}


variable "vpc_cidr" {
  type = string
}

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

variable "availability_zone_1" {
  type = string
}

variable "availability_zone_2" {
  type = string
}

variable "log_group_name" {

  type = string

}

variable "ecs_cluster_name" {
  type = string
}


variable "frontend_image" {
  type = string
}

variable "backend_image" {
  type = string
}