variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_route_table_ids" {
  type = list(string)
}

variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
