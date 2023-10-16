resource "shoreline_notebook" "slow_query_performance_in_postgresql" {
  name       = "slow_query_performance_in_postgresql"
  data       = file("${path.module}/data/slow_query_performance_in_postgresql.json")
  depends_on = [shoreline_action.invoke_create_index]
}

resource "shoreline_file" "create_index" {
  name             = "create_index"
  input_file       = "${path.module}/data/create_index.sh"
  md5              = filemd5("${path.module}/data/create_index.sh")
  description      = "Lack of proper indexing: If a large amount of data is being queried without proper indexing, the database engine may have to perform a lot of disk I/O to find the requested data. This can slow down query execution time significantly."
  destination_path = "/tmp/create_index.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_create_index" {
  name        = "invoke_create_index"
  description = "Lack of proper indexing: If a large amount of data is being queried without proper indexing, the database engine may have to perform a lot of disk I/O to find the requested data. This can slow down query execution time significantly."
  command     = "`chmod +x /tmp/create_index.sh && /tmp/create_index.sh`"
  params      = ["TABLE_NAME","DATABASE_NAME","COLUMN_NAME"]
  file_deps   = ["create_index"]
  enabled     = true
  depends_on  = [shoreline_file.create_index]
}

