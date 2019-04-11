data "local_file" "random-number" {
  filename = "../random-number"
}

data "aws_instance" "cloud-cluster" {
  filter {
    name   = "tag:Name"
    values = ["terraform-module-cloudon-testing-${data.local_file.random-number.content}-1"]
  }
}

variable "aws_vpc_id" {}
variable "aws_subnet_id" {}
variable "aws_security_group_id" {}

provider "rubrik" {
  node_ip  = "${data.aws_instance.cloud-cluster.private_ip}"
  username = "admin"
  password = "RubrikGoForward"
}

module "rubrik_aws_cloudout" {
  source               = "rubrikinc/rubrik-s3-cloudout/aws"
  bucket_name          = "rubrik-tf-cloudon-module-bucket-${data.local_file.random-number.content}"
  archive_name         = "S3:ArchiveLocation"
  bucket_force_destory = true
  iam_user_name        = "tf-module-cloudon-test-user-${data.local_file.random-number.content}"
  iam_policy_name      = "tf-module-cloudon-test-policy-${data.local_file.random-number.content}"
  kms_key_alias        = "tf-module-cloudon-test-policy-kms-${data.local_file.random-number.content}"
}

module "rubrik-s3-cloudon" {
  source            = "rubrikinc/rubrik-cloudon/aws"
  iam_user_name     = "${module.rubrik_aws_cloudout.aws_iam_user_name}"
  archive_name      = "${module.rubrik_aws_cloudout.rubrik_archive_name}"
  vpc_id            = "${var.aws_vpc_id}"
  subnet_id         = "${var.aws_subnet_id}"
  security_group_id = "${var.aws_security_group_id}"
}
