resource "tls_private_key" "ssh-key" {
  algorithm    = "RSA"
  rsa_bits     = "4096"
}

resource "aws_key_pair" "key_pair" {
    key_name = "Generated Key"
    public_key = tls_private_key.ssh-key.public_key_openssh
}

output priv_key {
    value = tls_private_key.ssh-key.private_key_pem
}

output gen_key_name {
    value = aws_key_pair.key_pair.key_name
}