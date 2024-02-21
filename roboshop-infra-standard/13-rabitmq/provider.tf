terraform{
    required_version = ">= 1.0"
  required_providers{
    aws ={
      source  = "hashicorp/aws"
      version = ">= 4.66"
    }
  }

  backend "s3"{
  bucket = "roboshop-adv"
  key = "rabitmq"
  region = "us-east-1"
  dynamodb_table = "roboshop-adv-table"
  }
}
provider "aws"{
  region = "us-east-1"
}