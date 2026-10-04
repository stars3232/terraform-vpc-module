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

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true 

  tags = merge(local.common_tags,{
         Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
         })
  

}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_blocks[count.index]
  availability_zone       = local.az_names[count.index] 

  tags = merge(local.common_tags,{
         Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
         })


}


resource "aws_subnet" "database" {
  count                   = length(var.database_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.database_subnet_cidr_blocks[count.index]
  availability_zone       = local.az_names[count.index] 

  tags = merge(local.common_tags,{
         Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
         })


}
