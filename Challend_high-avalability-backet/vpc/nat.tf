resource "aws_eip" "nat_eip" {
    depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_a.id
  depends_on = [ aws_internet_gateway.igw ]
}