terraform {
  backend "s3" {
    bucket         = "manishkumar-prod"
    key            = "my-terraform-environment/main"
    region         = "us-east-1"
    dynamodb_table = "terraformmanishdb"
  }
}
