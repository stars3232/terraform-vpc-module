resource "aws_vpc_peering_connection" "main" {
  count         = var.is_peering_required ? 1 : 0
  peer_vpc_id   = data.aws_vpc.default.id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags = merge(local.common_tags,{
               Name = "${var.project}-${var.environment}-peering"
               })
}

resource "aws_route" "public-default" {
  count                     = var.is_peering_required ? 1 : 0  
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "172.31.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
  
}

resource "aws_route" "default-public" {
  count                     = var.is_peering_required ? 1 : 0  
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
  
}