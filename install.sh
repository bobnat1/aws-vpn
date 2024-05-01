#!/bin/bash
read -p 'create or destroy? ' usrstart
if [ "$usrstart" = "destroy" ]; then
terraform destroy

elif [ "$usrstart" = "create" ]; then
echo "initializing Terraform.."
terraform init
terraform apply
echo "creating ssh key chain.."
sleep 3
terraform output -raw private_key > myKey.pem
terraform output public_ip_address > .env

read -p 'ssh into newly created instance? y/n: ' usrchoice
if [ "$usrchoice" = "y" ]; then
echo "connecting to newly created instance..."
sleep 3
chmod +x ssh.sh
bash ./ssh.sh
else echo "instance created."
fi

else echo "please enter valid input (create or destroy)"
fi