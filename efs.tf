resource "aws_efs_file_system" "myefs" {
  encrypted = true
  tags = {
    Name = "MyEFS"
  }
}

resource "aws_efs_mount_target" "az_1" {
  file_system_id  = aws_efs_file_system.myefs.id
  subnet_id       = aws_subnet.eprank_subnet_1.id
  security_groups = [aws_security_group.eprank_efs_sg.id]
  depends_on      = [aws_efs_file_system.myefs, aws_security_group.eprank_efs_sg]
}

resource "aws_efs_mount_target" "az_2" {
  file_system_id  = aws_efs_file_system.myefs.id
  subnet_id       = aws_subnet.eprank_subnet_2.id
  security_groups = [aws_security_group.eprank_efs_sg.id]
  depends_on      = [aws_efs_file_system.myefs, aws_security_group.eprank_efs_sg]
}