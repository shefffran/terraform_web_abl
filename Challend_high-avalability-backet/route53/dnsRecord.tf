resource "aws_route53_record" "ANameRecord" {
  zone_id = "Z06165763RPN23YUK73H4"
  name = "www"
  type = "A"

  alias {
    name = var.zone_name_id["dns_name"]
    zone_id = var.zone_name_id["zone_id"]
    evaluate_target_health = true
  }
}

variable "zone_name_id" {
  description = "adding zone and name id for dns record"
  type = map(string)
}