# The block below configures Terraform to use the 'remote' backend with Terraform Cloud.
# For more information, see https://www.terraform.io/docs/backends/types/remote.html
terraform {
  cloud {
    organization = "natebay-aws"

    workspaces {
      tags = ["jenkins", "aws", "docker"]
    }
  }

  required_version = ">= 1.1.7"
}
