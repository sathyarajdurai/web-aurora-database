data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"
    # values = ["al2023-ami-2023.0.20230614.0-kernel-6.1-x86_64"]
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230612.0-x86_64-gp2"]
  }

  owners = ["137112412989"] # Canonical
}