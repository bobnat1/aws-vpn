variable "ingressrules" {
  type    = list(number)
  default = [443, 943, 22]
}

variable "egressrules" {
  type    = list(number)
  default = [443, 943, 1194]
}

output "egress" {
    value = var.egressrules
}

output "ingress" {
    value = var.ingressrules
}