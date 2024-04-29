variable security {
    type = string
}

variable ssh_key {
    type = string
}


resource "aws_instance" "webserver" {
    ami             = "ami-0827b6c5b977c020e"
    instance_type   = "t2.micro"
    security_groups = [var.security]
    key_name = var.ssh_key

    tags = {
        Name = "Front End"
    }
}

output "pub_ip" {
    value = aws_instance.webserver.public_ip
}

output "instance_id" {
    value = aws_instance.webserver.id
}