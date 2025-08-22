data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-tf-state-bucket"
    key    = "eks-vpc-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnets

  eks_managed_node_groups = {
    cpu-nodes = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }

    gpu-nodes = {
      instance_types = ["g4dn.xlarge"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }

  tags = {
    Project = "eks-vpc-cluster"
  }
}
