terraform {
  backend "s3" {
    bucket = "a-s-bucket-kadai"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}
