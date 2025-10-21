resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(var.tags, { Name = "${var.name}-nat-eip" })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(var.public_subnet_ids, 0)
  tags          = merge(var.tags, { Name = "${var.name}-nat" })
}

resource "aws_route" "private_default" {
  for_each               = { for idx, id in var.private_route_table_ids : idx => id }
  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}
