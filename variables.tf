variable aws_region {
  description = "The AWS region to configure Rubrik Storm instances to run in"
}
variable "iam_user_name" {
  description = "The name of the IAM currently used for CloudOut."
}
variable "iam_policy_name" {
  description = "The name of the IAM Policy configured with the correct CloudOn permissions."
  default     = "rubrik-cloud-on"
}
variable "iam_vmimport_policy_name" {
  description = "The name of the IAM Policy configured with the correct permissions for the VM Import service."
  default     = "rubrik-vmimport-role"
}
variable "vpc_id" {
  description = "The id of the vpc used to run bolt."
}
variable "subnet_id" {
  description = "The id of the subnet used to run bolt."
}
variable "security_group_id" {
  description = "The id of the security group used to run bolt."
}
variable "timeout" {
  description = "Timeout value to be used when making Rubrik API call"
  default = 60
}