resource "aws_ssm_parameter" "main" {
  name  = "/roboshop/dev/vpc_id"
  type  = "String"
  value = "aws_vpc.main.id"
}