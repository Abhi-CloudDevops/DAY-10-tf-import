resource "aws_db_instance" "myDB" {
  identifier              = "database-1"
  instance_class          = "db.t4g.micro"
  engine                  = "mysql"
  engine_version          = "8.0.41"
  username                = "admin"
  allocated_storage       = 20
  copy_tags_to_snapshot   = true
  storage_encrypted       = true
  skip_final_snapshot     = true
  publicly_accessible     = false
  max_allocated_storage   = 1000
  vpc_security_group_ids  = ["sg-0496a0ae4a52c7b50"]
  db_subnet_group_name    = "default-vpc-0c901aec8df6b80aa"
#   parameter_group_name    = "default.mysql8.0"
#   option_group_name       = "default:mysql-8-0"
  backup_retention_period = 1
#   copy_tags_to_snapshot   = true
  storage_type            = "gp2"

  lifecycle {
    ignore_changes = [
      password,
    ]
  }
}
