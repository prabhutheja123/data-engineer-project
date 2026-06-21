terraform {
  backend "s3" {
    bucket         = "cdc-etl-tfstate-008538886516"
    key            = "bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cdc-etl-tflock"
    encrypt        = true
  }
}
