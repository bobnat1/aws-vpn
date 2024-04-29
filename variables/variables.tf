variable "ingressrules" {
  type    = list(number)
  default = [80, 443]
}

variable "egressrules" {
  type    = list(number)
  default = [80, 443, 3306, 53, 8080]
}

output "egress" {
    value = var.egressrules
}

output "ingress" {
    value = var.ingressrules
}