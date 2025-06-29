terraform {
  backend "s3" {
    bucket         = "supermanishprojext1"
    key            = "my-terraform-environment/main"
    region         = "us-east-1"
    dynamodb_table = "terraformmanishdb"
  }
}
