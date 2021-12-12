data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "server-key"
  public_key = file(var.mykey)

}

resource "aws_launch_configuration" "my_conf" {
  name_prefix                 = "My Launch Config with WP"
  image_id                    = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ssh_key.key_name
  security_groups             = [aws_security_group.eprank_ec2_sg.id]
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    encrypted   = false
  }
  user_data  = <<EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y php7.2
sudo yum install -y httpd php-mysqlnd
sudo systemctl start httpd
sudo systemctl enable httpd
mkdir -p /var/www/html
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.myefs.dns_name}:/ /var/www/html
EOF
  depends_on = [aws_security_group.eprank_ec2_sg, data.aws_ami.amazon_linux]
}

resource "aws_autoscaling_group" "my_asg" {
  name_prefix               = "my_asg"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  launch_configuration      = aws_launch_configuration.my_conf.name
  vpc_zone_identifier       = [aws_subnet.eprank_subnet_1.id, aws_subnet.eprank_subnet_2.id]
  load_balancers            = [aws_elb.my_elb.name]
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_elb.my_elb, aws_launch_configuration.my_conf, aws_efs_mount_target.az_1, aws_efs_mount_target.az_2]
}

resource "aws_elb" "my_elb" {
  name            = "My-ELB"
  security_groups = [aws_security_group.eprank_elb_sg.id]
  subnets         = [aws_subnet.eprank_subnet_1.id, aws_subnet.eprank_subnet_2.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:80"
    interval            = 20
  }

  cross_zone_load_balancing = true
  idle_timeout              = 60
  depends_on                = [aws_security_group.eprank_elb_sg]
}