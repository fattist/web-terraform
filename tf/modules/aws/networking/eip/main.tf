resource "aws_eip" "nat" {
  vpc = true
}

output "nat_eip_id" {
  value = "${aws_eip.nat.id}"
}

output "public_ip" {
  value = "${aws_eip.nat.public_ip}"
}
