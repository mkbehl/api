terraform {
  backend "s3" {
    bucket = "terraform-automation-s3-backend"
    key    = "hansen-pi-apigw-TEST.tfstate"
    dynamodb_table = "terraform-dev-account-version-locking"
    region = "us-west-2"
  }
}
