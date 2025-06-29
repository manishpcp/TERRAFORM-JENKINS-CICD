terraform {
  backend "s3" {
    bucket         = "manishproject29062025"
    key            = "my-terraform-environment/main"
    region         = "us-east-1"
    dynamodb_table = "terraformmanishdb"
  }
}
