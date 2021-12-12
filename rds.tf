resource "aws_db_instance" "mysql" {
  identifier                      = "mysql"
  engine                          = "mysql"
  engine_version                  = "5.7.33"
  instance_class                  = "db.t2.micro"
  db_subnet_group_name            = aws_db_subnet_group.default.name
  enabled_cloudwatch_logs_exports = ["general", "error"]
  name                            = var.db_name
  username                        = var.db_user
  password                        = data.aws_ssm_parameter.my_rds_password.value
  allocated_storage               = 20
  storage_type                    = "gp2"
  vpc_security_group_ids          = [aws_security_group.eprank_rds_sg.id]
  skip_final_snapshot             = true
  depends_on                      = [aws_security_group.eprank_rds_sg, aws_db_subnet_group.default]
}