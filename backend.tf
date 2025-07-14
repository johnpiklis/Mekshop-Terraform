terraform {
  backend "s3" {
    bucket = "mekshop-terraform-state-file"
    key    = "envs/prod/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"  # optional but recommended
  }
}
