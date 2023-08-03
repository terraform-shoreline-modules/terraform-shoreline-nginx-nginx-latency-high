resource "shoreline_notebook" "high_nginx_latency" {
  name       = "high_nginx_latency"
  data       = file("${path.module}/data/high_nginx_latency.json")
  depends_on = [shoreline_action.invoke_nginx_config_check,shoreline_action.invoke_nginx_config_test,shoreline_action.invoke_nginx_config_checker,shoreline_action.invoke_check_upstream_server]
}

resource "shoreline_file" "nginx_config_check" {
  name             = "nginx_config_check"
  input_file       = "${path.module}/data/nginx_config_check.sh"
  md5              = filemd5("${path.module}/data/nginx_config_check.sh")
  description      = "Check if Nginx configuration file exists"
  destination_path = "/agent/scripts/nginx_config_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "nginx_config_test" {
  name             = "nginx_config_test"
  input_file       = "${path.module}/data/nginx_config_test.sh"
  md5              = filemd5("${path.module}/data/nginx_config_test.sh")
  description      = "Check if Nginx configuration file test is successful"
  destination_path = "/agent/scripts/nginx_config_test.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "nginx_config_checker" {
  name             = "nginx_config_checker"
  input_file       = "${path.module}/data/nginx_config_checker.sh"
  md5              = filemd5("${path.module}/data/nginx_config_checker.sh")
  description      = "Check the Nginx configuration file and ensure that all the directives are properly configured."
  destination_path = "/agent/scripts/nginx_config_checker.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_upstream_server" {
  name             = "check_upstream_server"
  input_file       = "${path.module}/data/check_upstream_server.sh"
  md5              = filemd5("${path.module}/data/check_upstream_server.sh")
  description      = "Check the upstream server's status and ensure that it is properly configured."
  destination_path = "/agent/scripts/check_upstream_server.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_nginx_config_check" {
  name        = "invoke_nginx_config_check"
  description = "Check if Nginx configuration file exists"
  command     = "`chmod +x /agent/scripts/nginx_config_check.sh && /agent/scripts/nginx_config_check.sh`"
  params      = ["NGINX_CONFIG_FILE"]
  file_deps   = ["nginx_config_check"]
  enabled     = true
  depends_on  = [shoreline_file.nginx_config_check]
}

resource "shoreline_action" "invoke_nginx_config_test" {
  name        = "invoke_nginx_config_test"
  description = "Check if Nginx configuration file test is successful"
  command     = "`chmod +x /agent/scripts/nginx_config_test.sh && /agent/scripts/nginx_config_test.sh`"
  params      = []
  file_deps   = ["nginx_config_test"]
  enabled     = true
  depends_on  = [shoreline_file.nginx_config_test]
}

resource "shoreline_action" "invoke_nginx_config_checker" {
  name        = "invoke_nginx_config_checker"
  description = "Check the Nginx configuration file and ensure that all the directives are properly configured."
  command     = "`chmod +x /agent/scripts/nginx_config_checker.sh && /agent/scripts/nginx_config_checker.sh`"
  params      = ["PATH_TO_NGINX_CONFIG_FILE"]
  file_deps   = ["nginx_config_checker"]
  enabled     = true
  depends_on  = [shoreline_file.nginx_config_checker]
}

resource "shoreline_action" "invoke_check_upstream_server" {
  name        = "invoke_check_upstream_server"
  description = "Check the upstream server's status and ensure that it is properly configured."
  command     = "`chmod +x /agent/scripts/check_upstream_server.sh && /agent/scripts/check_upstream_server.sh`"
  params      = ["UPSTREAM_SERVER_URL","UPSTREAM_CONFIG_KEY"]
  file_deps   = ["check_upstream_server"]
  enabled     = true
  depends_on  = [shoreline_file.check_upstream_server]
}

