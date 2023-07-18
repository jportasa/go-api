module "mysql" {
  source = "../modules/mysql"

  name               = "mysql"
  namespace          = "prima"
  mysql_storage_size = "100Mi"
  mysql_user         = "prima"
}
