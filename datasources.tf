data "aws_availability_zones" "available" {
  state = "available"
}

/*output "az_info"  {
    value = data.aws_availability_zones.available.names
}*/

data "aws_vpc" "default" {
  default = true
}

/*output "default_vpc_id" {
  value = data.aws_vpc.default.id
}*/

data "aws_route_table" "default" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

output "default_route_table_id" {
  value = data.aws_route_table.default.id
}