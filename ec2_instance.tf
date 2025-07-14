data "template_file" "install_ansible" {
  template = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras enable ansible2
    yum install -y ansible
  EOF
}



resource "aws_instance" "docker" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "web-server" 
  vpc_security_group_ids = [aws_security_group.common_sg.id, aws_security_group.docker_sg.id]

  tags = {
    Name = "docker server"
  }
}

resource "aws_instance" "prometheus" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "web-server" 
  vpc_security_group_ids = [aws_security_group.common_sg.id, aws_security_group.prometheus_sg.id]

  tags = {
    Name = "prometheus server"
  }
}

resource "aws_instance" "grafana" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "web-server"  
  vpc_security_group_ids = [aws_security_group.common_sg.id, aws_security_group.grafana_sg.id]

  tags = {
    Name = "grafana server"
  }
}

resource "aws_instance" "ansible_control" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "web-server"
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  user_data = data.template_file.install_ansible.rendered

  tags = {
    Name = "ansible-control-node"
  }
}