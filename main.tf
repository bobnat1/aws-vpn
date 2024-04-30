provider "aws" {
    region = "us-west-1"
}

module "security" {
    source = "./sg"
}

module "ssh_key" {
    source = "./key"
}

module "front_end" {
    source = "./ec2"
    security = module.security.wt_name
    ssh_key = module.ssh_key.gen_key_name
}

output "private_key" {
    sensitive = true
    value = module.ssh_key.priv_key
}

output "public_ip_address" {
    value = module.front_end.pub_ip
}