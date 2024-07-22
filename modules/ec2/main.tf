
module "test_security_group" {
  source  = "terraform-aws-modules/security-group/aws"

   name = "test-sg"
   vpc_id = "${var.vpc_id}"

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "jenkins access"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  # egress  
  egress_with_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "test-key"
  public_key         = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCn00urt5q3InoTQYmX5HUOp4hlc358jZ7pfSijHm1RGIF35bR+fnoFTtg7BnX9sIrMhUdk9ewIqq/3rlsS259fjn7QrtRfIC7hX1vK2G5T1dKrhestqkQERpDCZO8l61UoOe6cUWJ0VSiOI4wRT6i0Klgmcr1mN7pVJ6b7uRfJjQVV9YVwgBkSOIK5taPqx7rv1CI0Y0SHaU2rfW5x9WzsD/dw+RpwfmqTWYFEhkrM7TbHhOzgdFvI7ekbC7Aeogw6ezjYg01alyz9Zdda3tYMQIZGZFdVnP8SLA+MJa75IFAbPh5gMOevfo1f4OKyjYQRy/BeA7GDt1o7rCDQWB3j"

}

module "test_instance_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                   = "test_instance"
  instance_type          = "t2.medium"
  ami                    = "ami-0c7217cdde317cfec"
  count                  = 1
  key_name               = "test-key"
  monitoring             = true
  vpc_security_group_ids = [module.test_security_group.security_group_id]
  subnet_id              = "${var.public_subnets[0]}"
  associate_public_ip_address = true


  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  echo "*** Installing java"
  sudo apt update -y
  sudo apt install fontconfig openjdk-17-jre -y
  echo "*** Completed Installing java"
  echo "*** Installing jenkins"
  sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian/jenkins.io-2023.key
  echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt-get update -y
  sudo apt-get install jenkins -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  echo "*** Completed Installing jenkins"
  EOF
  root_block_device = [
    {
      volume_size = 10
    },
  ]    

  tags = {
      Terraform   = "true"
      Environment = "test"
     
    }
}