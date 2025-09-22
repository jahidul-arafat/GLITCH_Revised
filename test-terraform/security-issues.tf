resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  # Hard-coded secrets
  user_data = <<-EOF
    #!/bin/bash
    export DB_PASSWORD="hardcoded123"
    export API_KEY="sk-1234567890abcdef"
    echo "admin:admin" | chpasswd
  EOF

  tags = {
    Name = "web-server"
    Password = "secret123"
  }
}

resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Web security group"

  # Invalid IP binding - allow all
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "data" {
  bucket = "my-data-bucket"

  # Weak encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}