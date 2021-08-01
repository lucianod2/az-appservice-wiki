variable "location"	{
  type        = string
  description = "Put your description here"
}
variable "postgresql-server-name"	{
  type        = string
  description = "Put your description here"
}
variable "postgresql-admin-login" {
  type        = string
  description = "Login to authenticate to PostgreSQL Server"
}
variable "postgresql-admin-password" {
  type        = string
  description = "Password to authenticate to PostgreSQL Server"
}
variable "postgresql-version" {
  type        = string
  description = "PostgreSQL Server version to deploy"
  default     = "11"
}
variable "postgresql-sku-name" {
  type        = string
  description = "PostgreSQL SKU Name"
  default     = "B_Gen5_1"
}
variable "postgresql-storage" {
  type        = string
  description = "PostgreSQL Storage in MB"
  default     = "5120"
}
variable "ad-login-user"	{
  type        = string
  description = "Put your description here"
}
variable "fw-rule-trick"	{
  type        = string
  description = "Put your description here"
}
variable "first_ip_address"	{
  type        = string
  description = "Put your description here"
}
variable "last_ip_address"	{
  type        = string
  description = "Put your description here"
}
variable "app-service-plan" {
  type        = string
  description = "Put your description here"
}
variable "app-service-sku-tier" {
  type        = string
  description = "Put your description here"
}
variable "app-service-sku-size" {
  type        = string
  description = "Put your description here"
}
variable "app-service-sku-capacity" {
  type        = string
  description = "Put your description here"
}
variable "appframework-version" {
  type        = string
  description = "Put your description here"
}
variable "docker-registry" {
  type        = string
  description = "Put your description here"
}
variable "db-type" {
  type        = string
  description = "Put your description here"
}
variable "db-host" {
  type        = string
  description = "Put your description here"
}
variable "db-port" {
  type        = string
  description = "Put your description here"
}
variable "db-name" {
  type        = string
  description = "Put your description here"
}
variable "db-user" {
  type        = string
  description = "Put your description here"
}

