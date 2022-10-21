# -------------------------------------------------------------------------#
# 変数定義
# -------------------------------------------------------------------------# 
variable "db_password"{
  default = "password"
}
variable "vpc_id" {
}
variable "db_subnet_group_name" {
}

# -------------------------------------------------------------------------#
# RDS設定
# -------------------------------------------------------------------------# 
resource "aws_db_instance" "rds" {
  identifier           = "terraform-db-instance"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "password"
  port                 = 3306
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = var.db_subnet_group_name

  tags = {
    Name = "rds-tf"
  }
}

# -------------------------------------------------------------------------#
# RDS Security Group
# -------------------------------------------------------------------------# 
resource "aws_security_group" "rds_sg" {
  name   = "rds-tf-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "rds-tf-sg"
  }

  ingress {
    from_port        = 3306
    to_port          = 3306
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
