
# Specify the provider and region here
provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Generate a random suffix for the S3 bucket name to ensure uniqueness
resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Create an S3 bucket
resource "aws_s3_bucket" "udabucket" {
  bucket = "cicd-terraform-demo-bucket-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "CICD test bucket"
    Environment = "Dev"
  }
}

# Lookup the latest Amazon Linux 2 AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create an EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "CICD test instance"
  }
}
