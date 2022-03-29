variable "public_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
  type    = list(string)
}

variable "private_cidr" {
  default = ["10.0.101.0/24", "10.0.102.0/24"]
  type    = list(string)
}

variable "availability_zone" {
  default = ["us-east-1a", "us-east-1b"]
  type    = list(string)
}
