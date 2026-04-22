data "aws_availability_zones" "az_zone" {
  state = "available"
}

output az_zones {
    value = data.aws_availability_zones.az_zone
}