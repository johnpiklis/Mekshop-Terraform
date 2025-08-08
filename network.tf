# Common security group for HTTP, HTTPS, and custom ports (shared by all)
resource "aws_security_group" "common_sg" {
  name        = "common-sg"
  description = "Allow HTTP, HTTPS, and custom app ports"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Custom ports (docker/prometheus/grafana)
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Docker Server SSH
resource "aws_security_group" "docker_sg" {
  name        = "docker-ssh-sg"
  description = "SSH access for docker server from my_ip and prometheus private IP"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]  
  }

  # SSH from Prometheus private IP (will set after we create prometheus instance)
  ingress {
    description      = "SSH from prometheus server private IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.prometheus_sg.id]  # referencing prometheus SG for private SSH
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Prometheus Server SSH
resource "aws_security_group" "prometheus_sg" {
  name        = "prometheus-sg"
  description = "SSH access for prometheus server from my IP"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]  
  }

    # Custom ports (docker/prometheus/grafana)
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Grafana Server SSH
resource "aws_security_group" "grafana_sg" {
  name        = "grafana-sg"
  description = "SSH access for grafana server from my IP"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]  
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ansible_sg" {
  name        = "ansible-control-sg"
  description = "Security group for Ansible control node"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]  # Allow SSH into control node only from your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}


# Allow SSH from Ansible control node to Docker Server
resource "aws_security_group_rule" "allow_ssh_from_ansible_to_docker" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.docker_sg.id
  source_security_group_id = aws_security_group.ansible_sg.id
  description              = "Allow SSH from Ansible control node"
}

# Allow SSH from Ansible control node to Prometheus Server
resource "aws_security_group_rule" "allow_ssh_from_ansible_to_prometheus" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.prometheus_sg.id
  source_security_group_id = aws_security_group.ansible_sg.id
  description              = "Allow SSH from Ansible control node"
}

# Allow SSH from Ansible control node to Grafana Server
resource "aws_security_group_rule" "allow_ssh_from_ansible_to_grafana" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.grafana_sg.id
  source_security_group_id = aws_security_group.ansible_sg.id
  description              = "Allow SSH from Ansible control node"
}
