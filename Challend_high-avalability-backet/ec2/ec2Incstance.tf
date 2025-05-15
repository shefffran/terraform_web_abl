resource "aws_instance" "ec2_instance" {
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  subnet_id = var.subnet_id_ec2_instances[count.index]//diff
  security_groups = [aws_security_group.web.id]
  key_name = "RSA-Key-EC2"
  count = length(var.name_of_instances)
  tags = {
    Name = var.name_of_instances[count.index] //diff
  }
  //diff 
  user_data = <<-EOF
                #!/bin/bash
                apt update -y
                apt install nginx -y
                systemctl start nginx
                systemctl enable nginx
                echo "<html><body><h1>EC2 Name: ${var.name_of_instances[count.index]}</h1></body></html>" > /var/www/html/index.html
              EOF

}

variable "subnet_id_ec2_instances" {
  type = list(string)
}

variable "name_of_instances" {
  type = list(string)
}
