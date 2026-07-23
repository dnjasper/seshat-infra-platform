# VPC

variable "vpc_cidr" {
   description = "The CIDR block for the VPC"
   type        = string
}

variable "project_name" {
    description = "The name of the project"
    type        = string
}

variable "environment" {
    description = "The environment of the project - i.e dev, staging, environment"
    type = string
}

## Subnets

variable "public_subnet_az1_cidr" {
    description = "The CIDR block for the public subnet in availability zone 1"
    type        = string
}
variable "public_subnet_az2_cidr" {
    description = "The CIDR block for the public subnet in availability zone 2"
    type        = string
}

variable "private_subnet_az1_cidr" {
    description = "The CIDR block for the private subnet in availability zone 1"
    type        = string
}

variable "private_subnet_az2_cidr" {
    description = "The CIDR block for the private subnet in availability zone 2"
    type        = string
}

