variable "region" {
  default = "us-east-1"
}

variable "ami" {
  default = "ami-0ecb62995f68bb549"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "your-key-name"
}

variable "security_group_id" {
  default = "your-sg-id"
}
