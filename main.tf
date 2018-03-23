

#This file spins up a new ec2 Server and Security Group

provider "aws" {

    shared_credentials_file = "${var.shared_credentials_file}"
    region     = "${var.aws_region}"
}

resource "aws_security_group" "lnx_web" {
  name        = "lnx_web"
  description = "Security group for devops-project"
  
	tags {
        Name = "lnx_web"
        }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    
  }
}

resource "aws_instance" "DevOpsProjectinstance" {
        ami = "ami-0b1e356e"
        instance_type ="${var.instance_type}"
        key_name = "${var.key_name}"
        subnet_id = "subnet-c87b99a0"
        vpc_security_group_ids = ["${aws_security_group.lnx_web.id}"]
        tags {
        Name = "DevOpsProjectInstance"
        }
		        
user_data = "${file("apache.sh")}"
user_data = "${file("ssl.sh")}"
user_data = "${file("testconfig.sh")}"

}
