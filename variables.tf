variable "prefix" {
  default = "Eprank"
}

variable "vpc_cider" {
  default = "10.99.0.0/16"
}


variable "subnet_1_cider" {
  default = "10.99.1.0/24"
}

variable "subnet_2_cider" {
  default = "10.99.2.0/24"
}

variable "region" {
  default = "eu-central-1"
}

variable "inet_cidr" {
  default = "0.0.0.0/0"
}


variable "instance_type" {
  default = "t2.micro"
}

variable "the_key" {
  default = "terra-stok"
}

variable "mykey" {
  default = "/Users/sergey/.ssh/aws_rsa.pub"

}

variable "ssh_key" {
  default = "/Users/sergey/.ssh/aws_rsa"
}

variable "db_name" {
  default = "wp_db"
}

variable "db_user" {
  default = "admin"
}

variable "name" {
  default = "random"
}
