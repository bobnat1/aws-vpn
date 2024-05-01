#!/bin/bash

file_id=$(<"./.env")
### scp into session with current shell and retrieves .ovpn file
eval $(echo "scp -i myKey.pem ec2-user@$file_id:/home/ec2-user/*.ovpn ./" | tr -d '"')
