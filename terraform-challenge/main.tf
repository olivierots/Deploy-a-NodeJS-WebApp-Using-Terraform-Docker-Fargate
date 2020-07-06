# my variables
variable "ingress_rules" {
  type = list(number)
  default = [80,443,25,3306,3389,8080]
}
  
variable "egress_rules" {
  type = list(number)
  default = [80,443,25,3306,3389,8080]
}

# my ec2
resource "aws_instance" "ec2" {
  ami           = "ami-0d8e27447ec2c8410"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.webserver.name]
}

# my security group
resource "aws_security_group" "webserver" {
  name = "web ports"


  dynamic "ingress"  {
      iterator = port 
      for_each = var.ingress_rules
      content {
         from_port = port.value
         to_port = port.value
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
      }
  }

  dynamic "egress"  {
        iterator = port
      for_each = var.egress_rules
      content {
         from_port = port.value
         to_port = port.value
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
      }
  }
}

# my elastic_ip
resource "aws_eip" "elastic_ip" {
  instance = aws_instance.ec2.id
}

# output the public IP
output "Public_IP" {
    value = aws_eip.elastic_ip.public_ip
}

# this output a list of expected ports to be open
output "expectedIngress" {
    value = [for i in var.ingress_rules : "Port ${i} expected to be open"]
}

output "expectedegress" {
    value = [for i in var.egress_rules : "Port ${i} expected to be open"]
}

# check if they are open on our firewall
output "actualingress" {
    value = aws_security_group.webserver[*].ingress
}

output "actualegress" {
    value = aws_security_group.webserver[*].egress
}


