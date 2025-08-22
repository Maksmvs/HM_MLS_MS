terraform {
  backend "s3" {
    bucket = "my-tf-state-bucket"
    key    = "eks-vpc-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}
