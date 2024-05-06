variable security {
    type = string
}

variable ssh_key {
    type = string
}


resource "aws_instance" "webserver" {
    ami             = "ami-0e0ece251c1638797"
    instance_type   = "t2.micro"
    security_groups = [var.security]
    key_name = var.ssh_key
    # user_data = file("ec2/openvpn-install.sh")

    tags = {
        Name = "VPN Server"
    }
}

output "pub_ip" {
    value = aws_instance.webserver.public_ip
}

output "instance_id" {
    value = aws_instance.webserver.id
}