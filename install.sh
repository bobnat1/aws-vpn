#!/bin/bash
terraform init
terraform apply
terraform output -raw private_key > myKey.pem
terraform output public_ip_address > ip.env
# Change ip
# ssh -i myKey.pem ec2-user@52.53.182.187