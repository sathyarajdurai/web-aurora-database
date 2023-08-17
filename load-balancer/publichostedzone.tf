# resource "aws_route53_zone" "public_common" {
#   name = "capci-gp4.aws.crlabs.cloud"
# }

resource "aws_route53_zone" "public_member" {
  name = "sathyaraj.aws.crlabs.cloud"


  tags = {
    Environment = "dev"
  }
}

# resource "aws_route53_record" "dev-ns" {
#   zone_id = aws_route53_zone.public_common.zone_id
#   name    = "capci-gp4.aws.crlabs.cloud"
#   type    = "NS"
#   ttl     = "30"
#   records = aws_route53_zone.public_member.name_servers
# }

resource "aws_route53_record" "alb_r53" {
  # checkov:skip=BC_AWS_GENERAL_95: ADD REASON bcoz of my ip
  zone_id = aws_route53_zone.public_member.zone_id
  name    = "resolve-test.sathyaraj.aws.crlabs.cloud"
  type    = "A"
  ttl     = 300
  records = ["192.168.25.4"]
}

