# -------------------------------------------------------------------------#
# 変数定義
# -------------------------------------------------------------------------# 
variable "vpc_id"{
}
variable "public_subnet_a"{
}

# -------------------------------------------------------------------------#
# EC2設定
# -------------------------------------------------------------------------# 
resource "aws_instance" "ec2" {
  ami                    = "ami-0ecb2a61303230c9d"
  instance_type          = "t2.micro"
  key_name               = "Ansible"
  subnet_id              = var.public_subnet_a
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<EOF
  #! /bin/bash
  sudo yum -y update
  EOF

  tags = {
    Name = "ec2-tf"
  }
}

# -------------------------------------------------------------------------#
# Linking EC2 and EIP
# -------------------------------------------------------------------------# 
resource "aws_eip_association" "eip_assoc"{
  instance_id = aws_instance.ec2.id
  public_ip   = "13.112.172.57"             # あらかじめEIPを取得する。そのパブリックIPアドレス
}

# -------------------------------------------------------------------------#
# EC2 Security Group
# -------------------------------------------------------------------------# 
resource "aws_security_group" "ec2_sg" {
  name   = "ec2-tf-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "ec2-tf-sg"
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# -------------------------------------------------------------------------#
# EC2インスタンスIDを外部モジュールに公開
# -------------------------------------------------------------------------# 
output "ec2_id"{
  value = aws_instance.ec2.id
}
