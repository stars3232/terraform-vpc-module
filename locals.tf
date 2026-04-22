locals  {
    common_tags = {
  project = var.project
  environment = var.environment
  terraform = true
    }

    az_zone_name = slice(data.aws_availability_zones.az_zone.names,0,2)
}