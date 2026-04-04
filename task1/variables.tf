variable "surname" {
  description = "Ваше прізвище латиницею"
  type        = string
  default     = "Struk"
}

variable "region" {
  description = "Регіон AWS, найближчий до України"
  type        = string
  default     = "eu-central-1"
}

variable "public_key" {
  description = "SSH Public Key for EC2 instance"
  type        = string
}