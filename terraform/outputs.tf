output "sql_password" {
  value = "${random_string.password.result}"
}