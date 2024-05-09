# AWS VPN
AWS VPN is an automated script designed to spin up a quick instance of an OpenVPN server using Terraform and Bash. After creating an EC2 instance on AWS it will automatically connect to the instance, install OpenVPN on the server, and retrieve .ovpn files for your clients. 

## Technologies Used
- AWS CLI
- Terraform
- Bash

## Prerequisites
In this current version **1.0** you will need the following dependecies installed:
- AWS CLI
- Terraform
- Bash (or other Shells)
You will need to be signed in into your AWS CLI with an IAM User that has superuser priviliges to ensure everything can be spun up without permission issues. This script was created with the intention of using the Free Tier of AWS so therefore I am only creating an AWS Linux 2 EC2 instance to prevent costs. **This script also assumes that the user will already have a IAM User, VPC, Subnet, and Gateway preconfigured before use.**\

## Installation
After ensuring you have the prerequisites installed, clone this repo and you will be good to go.

## Usage
In this current version **1.0** AWS VPN was designed to be ran within the command line. It has a Command Line Interface for users who prefer to take a step by step process of creating and deploying an OpenVPN server. To use the CLI, type:
```
bash aws-vpn.sh

```
This will thing bring up a menu within the command line that also shows the status of an active instance. From there you can choose to **Create** an .opvn file for a client, **Destroy** an instance, **SSH** into a currently active instance, or **Exit** the CLI.\
Note that **Create** actually initiates Terraform to create the EC2 instance within AWS, then the script will prompt you to SSH into the instance and install the OpenVPN server. **Create** will also generate and retrieve new client .opvn files after the instance is up and running with OpenVPN installed.\
\
After the OpenVPN server is up and running, you will be prompted to SSH into the instance incase you need to do any additional configuration. You can also manually SSH into your instance with the **SSH** option within the CLI. AWS VPN makes it easier to connect to your AWS by automatically retrieving and writing your AWS EC2 SSH .pem key to your current directory.\
\
When using the **Destroy** option - AWS VPN invoke the terraform destroy command to destroy your instances. Afterwards it will clean up your current directory by deleting your .opvn files and .pem SSH key. 

### Flags
Alongside the CLI for a more interactive experience, users can also opt into a more automated experience by using the flags provided by the script.\
- -c | --create     Create an instance
- -d | --destroy    Destroy an instance
- -s | --ssh        SSH into an instance
- -h | --help       Display help message
These flags do exactly the same thing as the CLI options, they just do not prompt the user and auto-accepts Terraform commands for complete automation. 

## Credits
This script was inspired by the great work of angristan and their openvpn-install script. The script to install openvpn on the EC2 instances was written by them, but was modified by me for a more complete automated experience. You can check out their repo for the script [here](https://github.com/angristan/openvpn-install)