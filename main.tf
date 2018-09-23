
#This file spins up a new ec2 Server and Security Group

provider "aws" {

    shared_credentials_file = "${var.shared_credentials_file}"
    region     = "${var.aws_region}"
}

resource "aws_security_group" "lnx_web" {
  name        = "hi"
  description = "bye"
  
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
/*
  connection {
            user = "ec2-user"
            private_key = "${file("/home/ec2-user/devops-project.pem")}"
            host = "${self.public_ip}"
            timeout = "2m"
        }
*/
provisioner "file" {
    source      = "/home/ec2-user/Terraform/httpd-setup/index.html"
    destination = "/home/ec2-user/index.html"
  }

provisioner "file" {
    source      = "/home/ec2-user/Terraform/httpd-setup/httpd.conf"
    destination = "/home/ec2-user/httpd.conf"
  }


provisioner "remote-exec" {
    inline = [
   "sudo yum install -y httpd mod_ssl && sudo cp /home/ec2-user/httpd.conf /etc/httpd/conf/httpd.conf && sudo service httpd restart",
   "sudo cp /home/ec2-user/index.html /var/www/html/index.html",
   "sudo mkdir -p /etc/httpd/ssl",
   "sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/httpd/ssl/apache.key -out /etc/httpd/ssl/apache.crt -subj \"/C=US/O=test/OU=Retirements/CN=example.com\"",
   "sudo service httpd restart && sudo apachectl configtest"
    ]
  }
		        
#user_data = "${file("apache.sh")}"
#user_data = "${file("ssl.sh")}"
#user_data = "${file("testconfig.sh")}"

}
