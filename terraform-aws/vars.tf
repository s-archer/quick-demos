variable "region" {
  description = "region to be used in AWS"
  default     = "eu-west-2"
}

variable "f5_ami_search_name" {
  description = "filter used to find AMI for deployment"
  default     = "F5*BIGIP-17.1*Best*25Mbps*"
  # default     = "F5*BIGIP-15.1.10*Best*25Mbps*"
}

variable "prefix" {
  description = "prefix used for naming objects created in AWS"
  default     = "arch-quickdemo-tf-"
}

variable "uk_se_name" {
  description = "UK SE name tag"
  default     = "arch"
}

variable "hostname-f5" {
  description = "Hostname for the BIG-IP, must be FQDN"
  default     = "bigip-1.f5demo.com"
}

variable "username" {
  description = "big-ip username"
  default     = "admin"
}

variable "instance_type" {
  description = "aws ec2 instance type"
  default     = "m5.xlarge"
}
