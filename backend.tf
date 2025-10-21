terraform {
  backend "s3" {
    bucket         = "terraform-task-eks-1"
    key            = "statefiles/sample-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-task-eks-locks"
    encrypt        = true
  }
}
