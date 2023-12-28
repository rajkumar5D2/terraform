
#vpc peering code, if required employee set is Peering_required = true to execute this code
resource "aws_vpc_peering_connection" "peering" {
  # peer_owner_id = var.peer_owner_id----account id not required
  count = var.isPeering_required ? 1 : 0
  peer_vpc_id   = aws_vpc.vpc.id # accepter, which is roboshop vpc public subnet 
  vpc_id        = var.requester_vpc_id # requester, which is default vpc
  auto_accept   = true

  tags = merge({
    Name = "vpc peering between default vpc and ${var.project_name}"
  }, var.common_tags)
}

resource "aws_route" "default_to_public_cidr" {
  route_table_id            = var.default_route_table_id #employee will give
  destination_cidr_block    = var.cidr_block # employee will give
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
#   depends_on                = [aws_route_table.testing] not required
}