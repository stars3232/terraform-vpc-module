variable "cidr_block" {
    default = "10.0.0.0/16"
}

variable "project" {
    
}

variable "environment" {
    
}

variable "public_subnet_cidr_blocks" {
    type = list(string)
}

variable "private_subnet_cidr_blocks" {
    type = list(string)
}

variable "database_subnet_cidr_blocks" {
    type = list(string)
}