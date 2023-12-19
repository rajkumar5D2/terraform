terraform{
  required_providers{
    aws ={
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
# backend "s3"{
#   bucket = "roboshop-dingu"
#   key = "for tfvars"
#   region = "us-east-1"
#   dynamodb_table = "roboshop-dingu-table"
#   }
}
provider "aws"{
  region = "us-east-1"
}