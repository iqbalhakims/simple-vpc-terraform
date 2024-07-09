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