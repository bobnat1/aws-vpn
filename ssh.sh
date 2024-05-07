#!/bin/bash

file_id=$(<"./.env")
### ssh into session with a sub shell
# echo "ssh -i myKey.pem ec2-user@$file_id" | tr -d '"' | bash - 
### ssh into session with current shell
eval $(echo "ssh -o 'StrictHostKeyChecking no' -i myKey.pem ec2-user@$file_id" | tr -d '"') 