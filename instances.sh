#!/bin/bash

function ssh_into_session {
    echo "connecting to ec2 instance..."
    sleep 3
    chmod +x ssh.sh
    bash ./ssh.sh   
}

function is_active_instance {
    if [ $(terraform state list | wc -c) -ne 0 ]; then
        ACTIVE_VM=true
    else
        ACTIVE_VM=false
    fi
}

ACTIVE_VM=false
# check if instance is active
is_active_instance

while :
do
    echo '  ______   __       __   ______         __     __  _______   __    __ 
    /      \ |  \  _  |  \ /      \       |  \   |  \|       \ |  \  |  \
    |  $$$$$$\| $$ / \ | $$|  $$$$$$\      | $$   | $$| $$$$$$$\| $$\ | $$
    | $$__| $$| $$/  $\| $$| $$___\$$      | $$   | $$| $$__/ $$| $$$\| $$
    | $$    $$| $$  $$$\ $$ \$$    \        \$$\ /  $$| $$    $$| $$$$\ $$
    | $$$$$$$$| $$ $$\$$\$$ _\$$$$$$\        \$$\  $$ | $$$$$$$ | $$\$$ $$
    | $$  | $$| $$$$  \$$$$|  \__| $$         \$$ $$  | $$      | $$ \$$$$
    | $$  | $$| $$$    \$$$ \$$    $$          \$$$   | $$      | $$  \$$$
    \$$   \$$ \$$      \$$  \$$$$$$            \$     \$$       \$$   \$$
                                                                               
                                        https://github.com/bobnat1/aws-vpn                                
                                                                        '
    echo "Active VM: $ACTIVE_VM"
    sleep 1

    # create or destroy ec2 instances
    read -p '(c)reate (d)estroy (s)sh (e)xit ' usrstartnf
    usrstart=$(echo "$usrstartnf" | awk '{print tolower($0)}')
    if [ "$usrstart" = "destroy" ] || [ "$usrstart" = "d" ]; then
        terraform destroy
        ACTIVE_VM=false
    
    elif [ "$usrstart" = "e" ] || [ "$usrstart" = "exit" ]; then
        break

    elif [ "$usrstart" = "s" ] || [ "$usrstart" = "ssh" ]; then
        if [ "$ACTIVE_VM" = "true" ]; then
            ssh_into_session
        else
            echo "no VPNs currently active"
            sleep 3
        fi
        
    elif [ "$usrstart" = "create" ] || [ "$usrstart" = "c" ]; then
        echo "initializing Terraform.."
        terraform init
        terraform apply
        echo "creating ssh key chain.."
        sleep 3
        terraform output -raw private_key > myKey.pem
        terraform output public_ip_address > .env
        ACTIVE_VM=true
        
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
            ssh_into_session
        else 
            echo "instance created."
        fi
        
    fi
done