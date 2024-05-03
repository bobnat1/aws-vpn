#!/bin/bash

function ssh_into_session {
    if is_active_instance
    then
        echo "connecting to ec2 instance..."
        sleep 3
        chmod +x ssh.sh
        bash ./ssh.sh
    else
        echo "no active instances"
        exit 1
    fi   
}

function is_active_instance {
    if [ $(terraform state list | wc -c) -ne 0 ]; then
        ACTIVE_VM=true
        return 0
    else
        ACTIVE_VM=false
        return 1
    fi
}

function destroy_instance {
    terraform destroy
    ACTIVE_VM=false
}

function create_instance {
    echo "initializing Terraform.."
    terraform init
    terraform apply
    if is_active_instance
     then
        echo "instance created!"
        echo "creating ssh key chain.."
        sleep 3
        terraform output -raw private_key > myKey.pem
        terraform output public_ip_address > .env
        ACTIVE_VM=true
    else
        echo "instance not created"
        exit 1
    fi
}

function openvpn_install {
        echo "installing script.."
        sleep 2
        bash ./install-open-vpn.sh
        echo "openvpn installed!"
        sleep 2 
        echo "retrieving .ovpn file for client.."
        sleep 2
        bash ./get-config.sh
        echo ".ovpn file retrieved!"
}

function usage {
 echo "Usage: $0 [OPTIONS]"
 echo "Options:"
 echo " -h, --help      Display this help message"
 echo " -d, --destroy   Destroy current instance"
 echo " -c, --create    Create an instance"
 echo " -s, --ssh       SSH into instance"
}

function handle_args {
    while [ $# -gt 0 ]; do  
        case $1 in
            -h | --help)
            echo "testing help"
            exit 0
            ;;
            -d | --destroy)
            destroy_instance
            exit 0
            ;;
            -c | --create)
            create_instance
            openvpn_install
            exit 0
            ;;
            -s | -ssh)
            ssh_into_session
            exit 0
            ;;
            *)
            echo "invalid option"
            usage
            exit 1
            ;;
        esac
        shift
    done
}

ACTIVE_VM=false
# check if instance is active
is_active_instance
# check for flags
handle_args "$@"

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

    # create/destroy/ssh into ec2 instances
    read -p '(c)reate (d)estroy (s)sh (e)xit ' usrstartnf
    usrstart=$(echo "$usrstartnf" | awk '{print tolower($0)}')
    if [ "$usrstart" = "destroy" ] || [ "$usrstart" = "d" ]; then
        destroy_instance
    
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
        create_instance
       # install open vpn on ec2 instance
        read -p 'install openvpn on newly created instance? y/n ' usrinstall
        if [ "$usrinstall" = "y" ]; then
            openvpn_install
        fi
    
        read -p 'ssh into newly created instance? y/n: ' usrchoice
        if [ "$usrchoice" = "y" ]; then
            ssh_into_session
        else 
            echo "instance created."
        fi
    fi
done