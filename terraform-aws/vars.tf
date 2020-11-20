variable "f5_ami_search_name" {
  description = "filter used to find AMI for deployment"
  default = "F5*BIGIP-15.1.0.4*Best*25Mbps*"
}

variable "prefix" { 
  description = "prefix used for naming objects created in AWS"
  default = "arch-quickdemo-tf-"
}

variable "uk_se_name" {
  description = "UK SE name tag"
  default     = "arch"
}

variable "hostname-f5" { 
  description = "Hostname for the BIG-IP, must be FQDN"
  default = "bigip-1.f5demo.com"
}

variable "username" { 
  description = "big-ip username"
  default = "admin"
}

variable "instance_type" { 
  description = "aws ec2 instance type"
  default = "t2.large"
}

# The following two vars are placeholder/empty vars.  The values are populated from a separate creds.tfvars file, stored
# outside of your repo folder. Use the -var-file=../creds/creds.tfvars flag when applying config to use the values from 
# your creds.tfvars file.  The creds.tfvars file must contain two variables defined like this (but not commented out):
#
# aws_access_key = "blahBlahBlah"
# aws_secret_key = "blahBlahBlahblahBlahBlah"

variable "aws_access_key" {}

variable "aws_secret_key" {}