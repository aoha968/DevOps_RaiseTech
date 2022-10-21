# -------------------------------------------------------------------------#
# 変数定義
variable "cidr_block" {
  default = "10.0.0.0/16"
}

# -------------------------------------------------------------------------#
# VPC設定
# -------------------------------------------------------------------------# 
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block     # VPCのIPv4 CIDR ブロック
  enable_dns_support   = true               # VPCでDNSサポートを有効/無効
  enable_dns_hostnames = true               # VPCでDNSホスト名を有効/無効

  tags = {
    Name = "vpc-tf"
  }
}

# -------------------------------------------------------------------------#
# Subnet Create
# -------------------------------------------------------------------------# 
resource "aws_subnet" "subnets_a" {
  count = 2

  vpc_id                  = aws_vpc.vpc.id                                         # VPC ID
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)     # サブネットの CIDR ブロック
  availability_zone       = "ap-northeast-1a"                                      # サブネットが存在する必要があるアベイラビリティーゾーン
  map_public_ip_on_launch = true                                                   # インスタンスの起動時にパブリック IP アドレスが割り当てられるかどうか
  tags = {
    Name = "tf-subnet-a${count.index}"
  }
}

resource "aws_subnet" "subnets_c" {
  count = 2

  vpc_id                  = aws_vpc.vpc.id                                          # VPC ID
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 2)  # サブネットの CIDR ブロック
  availability_zone       = "ap-northeast-1c"                                       # サブネットが存在する必要があるアベイラビリティーゾーン
  map_public_ip_on_launch = true                                                    # インスタンスの起動時にパブリック IP アドレスが割り当てられるかどうか
  tags = {
    Name = "tf-subnet-c${count.index + 2}"
  }
}

# -------------------------------------------------------------------------#
# Subnet Group Create
# -------------------------------------------------------------------------# 
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "tf-db-subnet-group"             # サブネットグループ名称
  subnet_ids = [                          # サブネットグループID
    aws_subnet.subnets_a[1].id,
    aws_subnet.subnets_c[1].id
  ]
  tags = {
    Name = "tf-db-subnet-group"
  }
}

# -------------------------------------------------------------------------#
# VPC ID を外部モジュールに公開
# -------------------------------------------------------------------------# 
output "vpc_id"{
  value = aws_vpc.vpc.id
}

# -------------------------------------------------------------------------#
# Public Subnet A を外部モジュールに公開
# -------------------------------------------------------------------------# 
output "public_subnet_a"{
  value = aws_subnet.subnets_a[0].id
}

# -------------------------------------------------------------------------#
# Public Subnet C を外部モジュールに公開
# -------------------------------------------------------------------------# 
output "public_subnet_c"{
  value = aws_subnet.subnets_c[0].id
}

# -------------------------------------------------------------------------#
# Subnet Group を外部モジュールに公開
# -------------------------------------------------------------------------# 
output "db_subnet_group"{
  value = aws_db_subnet_group.db_subnet_group.name
}
