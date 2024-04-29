module "security" {
    source = "./sg"
}

module "front_end" {
    source = "./ec2"
    security = module.security.wt_name
}

provider "aws" {
    region = "us-west-1"
}
