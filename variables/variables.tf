variable "ingressrules" {
  type    = list(number)
  default = [443, 943, 22, 1194, 80, 8080]
}

variable "egressrules" {
  type    = list(number)
  default = [443, 943, 1194, 80, 8080]
}

output "egress" {
    value = var.egressrules
}

output "ingress" {
    value = var.ingressrules
}