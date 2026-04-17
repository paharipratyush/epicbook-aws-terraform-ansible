output "public_ip" {
  value = aws_instance.web_vm.public_ip
}
output "rds_endpoint" {
  value = aws_db_instance.epicbook_db.address
}
output "admin_user" {
  value = "ubuntu"
}
