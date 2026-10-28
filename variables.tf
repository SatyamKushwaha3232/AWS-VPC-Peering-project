variable "aws_region" {
  description = "AWS Region for every lab resource."
  type        = string
  default     = "ap-south-1"
}

variable "student_name" {
  description = "Name applied to the Student tag."
  type        = string
}

variable "key_name" {
  description = "Existing EC2 key pair name in the selected Region."
  type        = string
  default     = "ewb-lab"
}

variable "admin_cidr" {
  description = "Your current public IPv4 address as a /32 CIDR, permitted to SSH to the bastion."
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0)) && can(regex("/32$", var.admin_cidr))
    error_message = "admin_cidr must be one IPv4 address with a /32 mask, for example 203.0.113.25/32."
  }
}

variable "instance_type" {
  description = "Small x86 EC2 instance type approved for the lab."
  type        = string
  default     = "t3.micro"
}
