
variable aws_region {
  description = "The AWS region to configure Rubrik Storm instances to run in"
}

variable "aws_vpc_security_group_name_storm" {
  description = "Name of the security group to create for Rubrik Storm instances to use."
  default     = "Rubrik Storm Instances"
}

variable "rubrik_cluster_cidr" {
  description = "The CIDR range of the Rubrik Cluster. (Used to allow ingress to Storm from the Rubrik Cluster)"
  default     = "10.0.0.0/24"
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

variable "bucket_name" {
  description = "The name of the S3 bucket used for CloudOn (this will be the same bucket as the CloudOut archival location uses)."
}

variable "vpc_id" {
  description = "The id of the vpc used to run bolt."
}
variable "subnet_id" {
  description = "The id of the subnet used to run bolt."
}
variable "timeout" {
  description = "Timeout value to be used when making Rubrik API call"
  default = 60
}