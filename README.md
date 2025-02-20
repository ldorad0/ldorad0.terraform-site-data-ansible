# Overview

This is a Terraform module that allows for sharing data between ansible and Terraform.

With this handy approach, you can make ansible the source of truth for all site data.

**Note**: I tested this approach on Ubuntu. It did not work from OSX Sequoia.

# Under the hood

The module accomplishes this like so:

1. Utilizes the [external](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) data source to:
  - Spawn a subprocess via `bash` that calls the `ansible` command against the specified inventory file
  - The output of the ansible command is json, and is processed as follows: 
    1. The subprocess base64-encodes the json value
    1. The Terraform [base64decode](https://developer.hashicorp.com/terraform/language/functions/base64decode) function decodes the base64-encoded value
    1. The Terraform [jsondecode](https://developer.hashicorp.com/terraform/language/functions/jsondecode) function decodes the decoded json

For the full details, consult [main.tf](main.tf).

# Outputs  

The module produces a single output variable, named `output`, see [outputs.tf](outputs.tf)

# Usage Example

First, refer to example included in this repository, [here](example).

You can refer to all of your ansible facts via `module.site_data.output`.

The world's the limit at this point, as you have Ansible's arsenal of extensibility for generating/retrieving facts and metadata.

For example, you can utilize the [bitwarden lookup plugin](https://docs.ansible.com/ansible/latest/collections/community/general/bitwarden_lookup.html) to have all your passwords stored in bitwarden, retrievable by ansible.

Sky's the limit!

# Appendix

## Troubleshooting Tips

1. If the subprocess fails for any reason, try running the subprocess yourself to see if you can spot any problems.
1. Even if the subprocess fails, you may still see a base64-encoded value in the Terraform error message.<br />
   Try decoding it to see if you can determine the cause for the failure.
1. Inspect the terraform invocation with **TRACE** logging enabled, as with `TF_LOG=TRACE terraform plan`