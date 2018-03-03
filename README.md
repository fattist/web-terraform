## Installation

[Terraform](https://www.terraform.io/)

# Services

- S3 : Terraform ops management
- AWS : contingent on application region
- Ansible/Ansible Vault : vault encryption
- AWS CLI

### Setup

[NVM](https://github.com/creationix/nvm)
[Terraform](https://www.terraform.io/)

```
nvm install
nvm use
```

```
npm i
npm i -g grunt-cli
```

### Terraform

This repository contains out-of-the box support for a full production build. Below is a dry-run command, re-run with `--apply` to confirm run.

To destroy an entire AZ append `--destroy` at the end of the command.

```
grunt terraform --env=production --region=west --zone=1
```

### Chores

If any decrypted secrets files are modified, the following command needs to be executed in order to commit the encrypted files.

```
grunt encrypt
```
