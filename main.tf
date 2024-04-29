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

provider "aws" {
    region = "us-west-1"
}
