provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "clo835_vm" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.medium"
  key_name      = aws_key_pair.ec2.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y

              # Install dependencies
              yum install -y unzip curl jq git

              # Install Docker
              amazon-linux-extras install docker -y
              systemctl enable docker
              systemctl start docker
              usermod -aG docker ec2-user

              # Install AWS CLI v2
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install

              # Install kubectl
              curl -LO "https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2023-11-14/bin/linux/amd64/kubectl"
              chmod +x kubectl
              mv kubectl /usr/local/bin/


              # Clean up
              rm -rf awscliv2.zip aws/
              EOF

  tags = {
    Name = "clo835-vm"
  }
}

resource "aws_key_pair" "ec2" {
  key_name   = "ec2"
  public_key = file("ec2_key.pub")
}

output "clo835_vm_public_ip" {
  description = "Public IP of the clo835-vm instance"
  value       = aws_instance.clo835_vm.public_ip
}
