data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_key_pair" "aws_training" {
  key_name   = "awstraining-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2tPPO2pFswoFjv6kzcgtm84RU0gpcJx9AhzMV8GuuKQQBKA5BpiRifL14T/A0wl1gEYunr+Kr7l1kZKuiLJuDDARHBVO9fHFJQZcXRRCboctAxJad7XqkSc5dm2Le3aUAbT26q6pCOEDY0CUbfzMYikMzdrxLgqHof79p5lVntHEjR3W25OJuEq+ig6kYrI9ucHh3dnwCxVg1xFmFJ41YGSjl2pCJ1iGgCvdswVIhF3yZlqRpHub5SCC9S6YrubRUKF3XOy2GZd5Z4BGcrCyOjX9May1ucyyhM6yWIYxQIUZlJn9XB6+qcI4X1vrBQTMwE2Pfijqx/HgbwOTPmG85i9HXJ1nNpgUUbUjZ7o9142d0fguYHKe8mrNm+lL57E+J2WkqdBN/N3hNKEKzzDlk3aWPRZKCoeseLqnyQ2zk72yIk4JwG/mHBuaOKnhnC/EJh30V1jHjRVthIHd3zVQsvtv1b68veSv/RYAehYod6vpOD4wQd/b1Fat1KJe+WIs="
}
