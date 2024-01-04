terraform{
  required_providers{
    aws ={
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3"{
  bucket = "roboshop-adv"
  key = "web-alb"
  region = "us-east-1"
  dynamodb_table = "roboshop-adv-table"
  }
}
provider "aws"{
  region = "us-east-1"
}