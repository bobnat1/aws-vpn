#!/bin/bash

file_id=$(<"./.env")
# ssh into instance and install script
eval $(echo "ssh -i myKey.pem ec2-user@$file_id" | tr -d '"') 'sudo bash -s < ./openvpn-install.sh'