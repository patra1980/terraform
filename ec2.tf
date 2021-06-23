resource "aws_instance" "web" {
  ami           = "ami-0aeeebd8d2ab47354"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.ibm-pub.id
  key_name      = "vir"
  tags = {
    Name = "TF Instance"
  }
}
