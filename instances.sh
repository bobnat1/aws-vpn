#!/bin/bash
# create or destroy ec2 instances
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
    
    read -p 'install openvpn on newly created instance? y/n ' usrinstall
    if [ "$usrinstall" = "y" ]; then
        echo "installing script.."
        sleep 2
        bash ./install-open-vpn.sh
        echo "openvpn installed!"
        sleep 2 
        echo "retrieving .ovpn file for client.."
        sleep 2
        bash ./get-config.sh
        echo ".ovpn file retrieved!"
    fi
    
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