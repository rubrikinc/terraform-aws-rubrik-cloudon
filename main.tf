#############
# Providers #
#############

provider "aws" {
  region = "${var.aws_region}"
}

##################
# AWS IAM Policy #
##################

resource "aws_iam_policy" "cloud-on-permissions" {
  name   = "${var.iam_policy_name}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid":  "RubrikCloudOnv50",
            "Effect": "Allow",
            "Action": [
              "kms:Encrypt",
              "kms:Decrypt",
              "kms:GenerateDataKeyWithoutPlaintext",
              "kms:GenerateDataKey",
              "kms:DescribeKey",
              "ec2:DescribeInstances",
              "ec2:CreateKeyPair",
              "ec2:CreateImage",
              "ec2:CopyImage",
              "ec2:DescribeSnapshots",
              "ec2:DeleteVolume",
              "ec2:StartInstances",
              "ec2:DescribeVolumes",
              "ec2:DescribeExportTasks",
              "ec2:DescribeAccountAttributes",
              "ec2:ImportImage",
              "ec2:DescribeKeyPairs",
              "ec2:DetachVolume",
              "ec2:CancelExportTask",
              "ec2:CreateTags",
              "ec2:RunInstances",
              "ec2:StopInstances",
              "ec2:CreateVolume",
              "ec2:DescribeImportSnapshotTasks",
              "ec2:DescribeSubnets",
              "ec2:AttachVolume",
              "ec2:DeregisterImage",
              "ec2:ImportVolume",
              "ec2:DeleteSnapshot",
              "ec2:DeleteTags",
              "ec2:DescribeInstanceAttribute",
              "ec2:DescribeAvailabilityZones",
              "ec2:CreateSnapshot",
              "ec2:ModifyInstanceAttribute",
              "ec2:DescribeInstanceStatus",
              "ec2:CreateInstanceExportTask",
              "ec2:TerminateInstances",
              "ec2:ImportInstance",
              "s3:CreateBucket",
              "s3:ListAllMyBuckets",
              "ec2:DescribeTags",
              "ec2:CancelConversionTask",
              "ec2:ImportSnapshot",
              "ec2:DescribeImportImageTasks",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeImages",
              "ec2:DescribeVpcs",
              "ec2:CancelImportTask",
              "ec2:DescribeConversionTasks"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "rubrik-user" {
  user       = "${var.iam_user_name}"
  policy_arn = "${aws_iam_policy.cloud-on-permissions.arn}"
}

################################
#     Configure CloudOn        #
################################

resource "rubrik_aws_s3_cloudon" "cloudon" {
  archive_name      = "${var.archive_name}"
  vpc_id            = "${var.vpc_id}"
  subnet_id         = "${var.subnet_id}"
  security_group_id = "${var.security_group_id}"
  timeout = "${var.timeout}"
}