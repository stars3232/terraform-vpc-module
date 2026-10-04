resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = merge(local.common_tags,{
         Name = "${var.project}-${var.environment}"
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags,{
         Name = "${var.project}-${var.environment}"
  })
}
