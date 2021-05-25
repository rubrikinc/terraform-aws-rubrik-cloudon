# Terraform Module - AWS Rubrik CloudOn

Terraform module that adds Cloud Compute Settings to an existing archive location. The following steps are completed by the module:

* Create a new IAM Policy with the correct permissions for CloudOn and attach it to the specified user.
* Configures Cloud Compute Settings on Rubrik cluster.

## Documentation

Here are some resources to get you started! If you find any challenges from this project are not properly documented or are unclear, please raise an issueand let us know! This is a fun, safe environment - don't worry if you're a GitHub newbie!

  - Only required to run the sample Rubrik command to update the Cloud Compute settings for the Archival Location.

### Usage

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

## Inputs

The following are the variables accepted by the module.

| aws_region                        | The AWS region to configure Rubrik Storm instances to run in.                                                    | string |                        |   yes    |

## Prerequisites

There are a few services you'll need in order to get this project off the ground:

  - Only required to run the sample Rubrik command to update the Cloud Compute settings for the Archival Location.

## How You Can Help

We glady welcome contributions from the community. From updating the documentation to adding more functions for Python, all ideas are welcome. Thank you in advance for all of your issues, pull requests, and comments! :star:

* [Contributing Guide](CONTRIBUTING.md)
* [Code of Conduct](CODE_OF_CONDUCT.md)

## License

* [MIT License](LICENSE)

## About Rubrik Build

We encourage all contributors to become members. We aim to grow an active, healthy community of contributors, reviewers, and code owners. Learn more in our [Welcome to the Rubrik Build Community](https://github.com/rubrikinc/welcome-to-rubrik-build) page.

We'd  love to hear from you! Email us: build@rubrik.com 
