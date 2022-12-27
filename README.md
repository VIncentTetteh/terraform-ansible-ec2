# terraform-ansible-ec2

This example shows how to to create an EC2 instance and install nginx server using Ansible
Make sure you replace the values in the local

locals {
  vpc_id           = "" --> insert your aws vpc id here
  subnet_id        = "" --> insert your vpc subnet id here
  ssh_user         = "" --> insert your ssh user name here
  key_name         = "" --> insert your keypair name here
  private_key_path = "" --> insert the path to your aws keypair
}
