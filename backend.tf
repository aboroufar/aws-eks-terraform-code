terraform {
  backend "s3" {
    bucket       = "amir-tfstate-bucket-name"
    key          = "eks-infra/terraform.tfstate" # Dedicated key
    region       = "eu-west-1"
    use_lockfile = "true"
    encrypt      = true
  }
}