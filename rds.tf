resource "aws_security_group" "database_sg_rds" {
  name = "rds-ec2-sg"
  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = [aws_security_group.instance_security_group.id]
  }
}


resource "aws_db_instance" "app_db" {
  allocated_storage      = 20
  identifier             = "pokemon-db"
  db_name                = "pokemon"
  engine                 = "mariadb"
  engine_version         = "10.6.11"
  instance_class         = "db.t3.micro"
  username               = "aayush_paras"
  password               = "my_cool_secret"
  parameter_group_name   = "default.mariadb10.6"
  option_group_name      = "default:mariadb-10-6"
  skip_final_snapshot    = true
  availability_zone      = "ap-south-1a"
  publicly_accessible    = false
  port                   = 3306
  vpc_security_group_ids = [aws_security_group.database_sg_rds.id]

}
