# 1. Віртуальна приватна хмара (VPC)
resource "aws_vpc" "main" {
  cidr_block           = "10.10.10.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.surname}-vpc"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.10.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 2. Налаштування фаєрволу
resource "aws_security_group" "firewall" {
  name        = "${var.surname}-firewall"
  description = "Exam firewall rules"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = [22, 80, 443, 8000, 8001, 8002, 8003]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 1
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# 3. ВМ
resource "aws_instance" "node" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.firewall.id]

  tags = {
    Name = "${var.surname}-node"
  }
}

# 4. Сховище для обʼєктів (бакет)
resource "aws_s3_bucket" "exam_bucket" {
  bucket = "${lower(var.surname)}-bucket-${random_id.bucket_id.hex}"

  tags = {
    Name = "${var.surname}-bucket"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}