resource "aws_instance" "task_server" {
  count                  = 2
  ami                    = "ami-0ed9277fb7eb570c9"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.Ec2SG.id]
  tags = {
    "Name" = "task_server_${count.index}"
  }
  key_name  = "terra-key"
  user_data = <<EOF
  #!/bin/bash
  sudo yum install httpd -y
  sudo service  httpd start
  sudo chkconfig httpd on
  echo "<h1>Deployed via Terraform</h1>" >> /var/www/html/index.html
  EOF
}