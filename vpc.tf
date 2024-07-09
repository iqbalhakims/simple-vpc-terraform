//create vpc 
resource "aws_vpc" "vpc-terra" {
    cidr_block = "10.0.0.0/16"

    tags = {

        Name = " my-vpciaq"
    }


}

//create public subnet 

resource "aws_subnet" " public-subnet" {
    vpc_id = "aws.vpc.vpc-terra.id"
    cidr_block = "10.0.1.0/24" 
}
//create private subnet 
resource " "aws_vpc"" "private-subnet" {
    vpc_id = "aws.vpc.vpc-terra.id"
    cidr_block = "10.0.2.0/24"
  
}

//create internet gateway
resource "aws_intenet_gateway" "terra-gw"{
    vpc_id = "aws.vpc.vpc-terra.id"
    
    tags = {
        Name = "terra-gw"
    }
}
//create route table
resource "aws_route_table" "Publicrt" {
    vpc_id = "aws.vpc.vpc-terra.id"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "aws.internet.gateway.terra-gw.id"
    }
}
//create rt association
resource "aws_route_tables_association" "PriRTasso"{
    subnet_id = "aws.subnet.public-subnet.id"
    route_table_id = "aws.route.table.Publicrt.id"
}

# Security Group
resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-sg"
  }
}

# EC2 Instance in Public Subnet
resource "aws_instance" "public_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public-server.id
  security_groups = [aws_security_group.main.name]

  tags = {
    Name = "public-instance"
  }
}

# EC2 Instance in Private Subnet
resource "aws_instance" "private_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private-subnet.id
  security_groups = [aws_security_group.main.name]

  tags = {
    Name = "private-instance"
  }
}