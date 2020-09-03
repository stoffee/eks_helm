resource "aws_db_instance" "buildlydb" {
  allocated_storage    = 100
  db_subnet_group_name = module.vpc.database_subnet_group
  engine               = "postgres"
  engine_version       = "11.5"
  identifier           = "${var.db_name}-${random_string.suffix.result}"
  instance_class       = var.db_instance_class
  password             = var.db_password
  skip_final_snapshot  = true
  storage_encrypted    = true
  username             = var.db_username
  vpc_security_group_ids = [
      module.vpc.default_vpc_default_security_group_id,
      #module.vpc.default_security_group_id,
  ]
  timeouts {
    delete = "2h"
  }
}
