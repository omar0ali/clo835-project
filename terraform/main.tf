provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
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
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.ec2.key_name
  vpc_security_group_ids = [aws_security_group.ssh_access.id]



  user_data = <<-EOF
  #!/bin/bash
  set -e
  set -x

  sleep 10

  # Install packages
  yum update -y
  yum install -y unzip curl jq git bash-completion

  # Docker setup
  amazon-linux-extras install docker -y
  systemctl enable docker --now
  usermod -aG docker ec2-user

  # AWS CLI
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
  unzip awscliv2.zip && ./aws/install

  # Kubernetes tools
  curl -LO "https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl" \
    && chmod +x kubectl && mv kubectl /usr/local/bin/
  curl -sSL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" \
    | tar xz -C /tmp && mv /tmp/eksctl /usr/local/bin

  # Python
  yum install -y python3
  pip3 install boto3

  # Write to BOTH .bashrc and /etc/profile.d for maximum coverage
  cat >> /home/ec2-user/.bashrc <<'EOL'
  export TERM=xterm
  export PATH=$PATH:/usr/local/bin
  export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text || echo "")
  EOL

  # Also add to global profile
  cat > /etc/profile.d/eks_env.sh <<'EOL'
  export TERM=xterm
  export PATH=$PATH:/usr/local/bin
  [ -x "$(command -v aws)" ] && export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text || echo "")
  EOL

  # Fix permissions
  chown ec2-user:ec2-user /home/ec2-user/.bashrc
  chmod 644 /home/ec2-user/.bashrc /etc/profile.d/eks_env.sh

  # Cleanup
  rm -rf awscliv2.zip aws/
  EOF

  tags = {
    Name = "clo835-vm"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ec2-user/.aws"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("ec2_key")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "~/.aws/credentials"
    destination = "/home/ec2-user/.aws/credentials"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("ec2_key")
      host        = self.public_ip
    }
  }
}

resource "aws_security_group" "ssh_access" {
  name        = "clo835-ssh-sg"
  description = "Allow SSH access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "clo835-ssh-sg"
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
