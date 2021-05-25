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
              "ec2:DescribeConversionTasks",
              "iam:PutRolePolicy",
              "iam:CreateRole"
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

# Note: if an existing policy exists with the name "vmimport" and is configured as
# this policy is, this resource can be removed. If this resoruce is removed the 
# policy assigment for the "vmimport" role below will need to be altered with the role
# arn id of the existing "vmimport" role. 
resource "aws_iam_role" "rubrik-vmimport" {
  name               = "vmimport"
  path               = "/"
  assume_role_policy = <<EOF
{
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Principal": { "Service": "vmie.amazonaws.com" },
              "Action": "sts:AssumeRole",
              "Condition": {
                "StringEquals": { "sts:Externalid": "vmimport" }
              }
            }
          ]
        }
EOF
}

resource "aws_iam_policy" "rubrik-vmimport" {
  name   = "${var.iam_vmimport_policy_name}"
  policy = <<EOF
{
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Action": [
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket"
              ],
              "Resource": [
                  "arn:aws:s3:::${var.bucket_name}",
                  "arn:aws:s3:::${var.bucket_name}/*"
              ]
            },
            {
              "Effect": "Allow",
              "Action": [
                "ec2:ModifySnapshotAttribute",
                "ec2:CopySnapshot",
                "ec2:RegisterImage",
                "ec2:Describe*"
              ],
              "Resource": "*"
            }
          ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "rubrik-vmimport" {
  role       = aws_iam_role.rubrik-vmimport.name
  policy_arn = aws_iam_policy.rubrik-vmimport.arn
}

#################################################
# Security Group for the Rubrik Storm Instances #
#################################################

resource "aws_security_group" "rubrik-storm" {
  name        = "${var.aws_vpc_security_group_name_storm}"
  description = "Allow Rubrik Cluster to talk to Rubrik Storm and intra Storm communication"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description      = "Intra Storm communication"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self             = true
  }

  ingress {
    description      = "Cluster to Storm communication"
    from_port        = 2002
    to_port          = 2002
    protocol         = "tcp"
    cidr_blocks      = ["${var.rubrik_cluster_cidr}"]
  }

  ingress {
    description      = "Cluster to Storm communication"
    from_port        = 7785
    to_port          = 7785
    protocol         = "tcp"
    cidr_blocks      = ["${var.rubrik_cluster_cidr}"]
  }

  ingress {
    description      = "Cluster to Storm communication"
    from_port        = 8077
    to_port          = 8077
    protocol         = "tcp"
    cidr_blocks      = ["${var.rubrik_cluster_cidr}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

###################
# AWS Endpoints   #
###################

# Note: It is Rubrik's and AWS' best proactice to use a S3 endpoint when accessing 
# S3 data from EC2 instances. In cases where intenret access is not allowd 
# from EC2 instances using a S3 endpoint is required. If a S3 endpoint already 
# exists or is not desired this resource can be removed. 

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${var.vpc_id}"
  service_name = "com.amazonaws.${var.aws_region}.s3"
}

# NOTE: It is Rubrik's and AWS' best practice to use a KMS endpoint when accessing
# KMS dat from EC2 instances. In cases where intenret access is not allowd 
# from EC2 instances using a KMS endpoint is required. If a KMS endpoint already
# exists or is not desired this resoruce can be removed.

resource "aws_vpc_endpoint" "kms" {
  vpc_id             = "${var.vpc_id}"
  subnet_ids         = ["${var.subnet_id}"]
  security_group_ids = ["${aws_security_group.rubrik-storm.id}"]
  vpc_endpoint_type  = "Interface"
  service_name       = "com.amazonaws.${var.aws_region}.kms"
}
