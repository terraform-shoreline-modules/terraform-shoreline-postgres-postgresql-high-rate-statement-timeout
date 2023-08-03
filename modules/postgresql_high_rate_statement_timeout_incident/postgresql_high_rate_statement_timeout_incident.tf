resource "shoreline_notebook" "postgresql_high_rate_statement_timeout_incident" {
  name       = "postgresql_high_rate_statement_timeout_incident"
  data       = file("${path.module}/data/postgresql_high_rate_statement_timeout_incident.json")
  depends_on = [shoreline_action.invoke_update_pg_config_timeout,shoreline_action.invoke_optimize_query]
}

resource "shoreline_file" "update_pg_config_timeout" {
  name             = "update_pg_config_timeout"
  input_file       = "${path.module}/data/update_pg_config_timeout.sh"
  md5              = filemd5("${path.module}/data/update_pg_config_timeout.sh")
  description      = "Define the variables"
  destination_path = "/agent/scripts/update_pg_config_timeout.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "optimize_query" {
  name             = "optimize_query"
  input_file       = "${path.module}/data/optimize_query.sh"
  md5              = filemd5("${path.module}/data/optimize_query.sh")
  description      = "Optimize the queries being executed in the database to reduce the load and prevent timeouts."
  destination_path = "/agent/scripts/optimize_query.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_pg_config_timeout" {
  name        = "invoke_update_pg_config_timeout"
  description = "Define the variables"
  command     = "`chmod +x /agent/scripts/update_pg_config_timeout.sh && /agent/scripts/update_pg_config_timeout.sh`"
  params      = ["NEW_TIMEOUT_VALUE"]
  file_deps   = ["update_pg_config_timeout"]
  enabled     = true
  depends_on  = [shoreline_file.update_pg_config_timeout]
}

resource "shoreline_action" "invoke_optimize_query" {
  name        = "invoke_optimize_query"
  description = "Optimize the queries being executed in the database to reduce the load and prevent timeouts."
  command     = "`chmod +x /agent/scripts/optimize_query.sh && /agent/scripts/optimize_query.sh`"
  params      = ["DATABASE_USER","DATABASE_PASSWORD","DATABASE_NAME","DATABASE_HOST","DATABASE_PORT"]
  file_deps   = ["optimize_query"]
  enabled     = true
  depends_on  = [shoreline_file.optimize_query]
}

