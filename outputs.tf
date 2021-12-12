output "mymount" {
  value = aws_efs_file_system.myefs.dns_name
}

output "elb_dns_name"{
  value = aws_elb.my_elb.dns_name
}