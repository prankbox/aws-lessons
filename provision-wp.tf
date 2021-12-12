resource "local_file" "wp_config" {
  filename = "./ansible/wp-config.php"
  content = templatefile("./wp-config.tmpl", {
    database_name = var.db_name
    username      = var.db_user
    password      = data.aws_ssm_parameter.my_rds_password.value
    db_host       = aws_db_instance.mysql.endpoint
  })
  depends_on = [aws_db_instance.mysql, aws_autoscaling_group.my_asg]
}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
    working_dir = "./ansible"
    command     = "ansible-playbook -i demo.aws_ec2.yml wp.yml -u ec2-user -b --private-key=${var.ssh_key}"
  }
  depends_on = [local_file.wp_config]
}