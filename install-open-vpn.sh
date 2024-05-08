#!/bin/bash

file_id=$(<"./.env")
# ssh into instance and install script
if eval $(echo "ssh -o 'StrictHostKeyChecking no' -i myKey.pem ec2-user@$file_id" | tr -d '"') 'sudo bash -s < ./openvpn-install.sh' 2>tf.log ; then
    :
else 
    echo "something went wrong connecting to instance. Check tf.log for more info."
    exit 1
fi