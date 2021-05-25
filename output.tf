output "vpc_id" {
    description = "ID of the VPC for the Rubrik Archival Location Cloud Compute settings."
    value       = "${var.vpc_id}"
}

output "subnet_id" {
    description = "The Subnet ID for the Rubrik Archival Location Cloud Compute settings."
    value       = "${var.subnet_id}"
}

output "security_group_id" {
    description = "ID of the Security Group ID for the Rubrik Archval Location Cloud Compute settings."
    value       = "${aws_security_group.rubrik-storm.id}"
}