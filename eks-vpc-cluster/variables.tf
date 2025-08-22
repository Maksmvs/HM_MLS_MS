variable "vpc_name" { default = "eks-vpc" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}
variable "cluster_name" { default = "eks-cluster" }
