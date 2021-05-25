# Quick Start: AWS S3 Rubrik CloudOn Terraform Module

Adds Cloud Compute Settings to an existing archive location. The following steps are completed by the module:

- Create a new IAM Policy with the correct permissions for CloudOn and attach it to the specified user.
- Create a new IAM Role with the correct permissions for CloudOn to use the AWS VMImport service.
- Create a new Security Group to allow the Rubrik Cluster to talk to the Rubrik Storm instances.
- Create S3 and KMS endpoints so that Rubrik Storm can keep data on the AWS network.
- Configures Cloud Compute Settings on Rubrik cluster.

Completing the steps detailed below will require that Terraform is installed and in your environment path, that you are running the instance from a \*nix shell (bash, zsh, etc).

## Configuration

In your [Terraform configuration](https://learn.hashicorp.com/terraform/getting-started/build#configuration) (`main.tf`) populate the following and update the variables to your specific environment:

```hcl
module "rubrik_aws_cloudon" {
  source = "rubrikinc/rubrik-cloudon/aws"

  iam_user_name  = "rubrik"
  archive_name = "S3:ArchiveLocation"
  vpc_id = "vpc-12345678901234567"
  subnet_id = "subnet-12345678901234567"
  security_group_id = "sg-12345678901234567"
}
```

You may also add additional variables, such as `iam_policy_name`, to overwrite the default values.

## Inputs

The following are the variables accepted by the module.

| Name                              | Description                                                                                                      |  Type  |        Default         | Required |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------- | :----: | :--------------------: | :------: |
| aws_region                        | The AWS region to configure Rubrik Storm instances to run in.                                                    | string |                        |   yes    |
| aws_vpc_security_group_name_storm | Name of the security group to create for Rubrik Storm instances to use.                                          | string | Rubrik Storm Instances |   yes    |
| rubrik_cluster_cidr               | The CIDR range of the Rubrik Cluster. (Used to allow ingress to Storm from the Rubrik Cluster). Format x.x.x.x/y | string |                        |   yes    |
| iam_user_name                     | The name of the IAM currently used for CloudOut to create.                                                       | string |                        |   yes    |
| iam_policy_name                   | The name of the IAM Policy to be created with the correct CloudOut permissions.                                  | string |    rubrik-cloud-out    |    no    |
| iam_vmimport_policy_name          | The name of the IAM Policy configured with the correct permissions for the VM Import service.                    | string |  rubrik-vmimport-role  |   yes    |
| bucket_name                       | The name of the S3 bucket used for CloudOn from the Archival Location.                                           | string |                        |   yes    |
| vpc_id                            | The id of the vpc used to run bolt.                                                                              | string |                        |   yes    |
| subnet_id                         | The id of the subnet used to run bolt.                                                                           | string |                        |   yes    |
| timeout                           | Timeout value to be used when making Rubrik API call.                                                            | number |           60           |    no    |

## Running the Terraform Configuration

This section outlines what is required to run the configuration defined above.

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v0.15.4 or greater
- [Rubrik Provider for Terraform](https://github.com/rubrikinc/rubrik-provider-for-terraform) - provides Terraform functions for Rubrik
  - Only required to run the sample Rubrik command to update the Cloud Compute settings for the Archival Location.

### Initialize the Directory

The directory can be initialized for Terraform use by running the `terraform init` command:

```none
Initializing modules...
- module.rubrik_aws_cloudon
  Getting source "rubrikinc/aws-rubrik-cloudon/module"

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 2.2"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Planning

Run `terraform plan` to get information about what will happen when we apply the configuration; this will test that everything is set up correctly.

### Applying

We can now apply the configuration to create the cluster using the `terraform apply` command.

### Destroying

If CloudOn is no longer required, this configuration can be destroyed using the `terraform destroy` command, and entering `yes` when prompted.
