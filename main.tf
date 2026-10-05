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


resource "aws_eip" "this" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(local.common_tags,{
         Name = "${var.project}-${var.environment}"
  })

depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags,{
         Name = "${var.project}-${var.environment}-public"
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags,{
         Name = "${var.project}-${var.environment}-private"
  })
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags,{
         Name = "${var.project}-${var.environment}-database"
  })
}


resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.gw.id
  
}


resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.example.id
  
}
  

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.example.id
  
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count          = length(var.database_subnet_cidr_blocks)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

