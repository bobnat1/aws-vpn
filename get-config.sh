#!/bin/bash

file_id=$(<"./.env")
### scp into session with current shell and retrieves .ovpn file
if eval $(echo "scp -o 'StrictHostKeyChecking no' -i myKey.pem ec2-user@$file_id:/home/ec2-user/*.ovpn ./" | tr -d '"') 2>tf.log ; then
    :
else
    echo "something went wrong connecting to instance. Check tf.log for more info."
    exit 1
fi