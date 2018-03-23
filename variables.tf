variable "shared_credentials_file" {
  description = "AWS shared credentials file"
  default     = "/home/ec2-user/.aws/credentials" 
}
variable "aws_region" {
  description = "The AWS region to Launch my Instance"
  default     = "us-east-2"
}

variable "key_name" {
  description = "Name of AWS key pair"
  default     = "devops-project"
}

variable "instance_type" {
  description = "Type of AWS instance"
  default     = "t2.micro"
  }
