### What Is This?
Terraform (Infrastructure-as-Code) and Bash automation to build a cloud instance with [evilnginx2](https://github.com/kgretzky/evilginx2) installed.

The Bash automation will:
- Install necessary packages for building evilnginx2 from source
- Build evilnginx2 from source
- Install an example phishlet

By default, Debian 11 is used as the instance OS. This can be modified by passing a `ami_id` variable to the respective Terraform dir for your chosen cloud provider.

## Disclaimer
Don't use this for anything illegal. This project is only for educational and legal security purposes.

### How Do I Use It? (ALL CLOUDS)

No matter which cloud provider you use, you will need an SSH key pair, which will be used to connect to the instance after deployment.

Using the ssh-keygen utility, run a command like the following:
- `ssh-keygen -t rsa -b 4096`

Then complete the subsequent dialogue steps as necessary. NEVER SHARE THE PRIVATE KEY, only ever use the PUBLIC key (file ending in `.pub`) within the Terraform automation.

You will also need a domain from which to host your evilnginx2 proxy. [See the evilnginx2 docs here.](https://help.evilginx.com/docs/getting-started/deployment/remote#domain--dns-setup) NOTE: You won't have an IP address yet to point your DNS records to, since you haven't yet deployed the Terraform automation. You can hold off on that part for now, and just set it later after you've deployed the instance. The important thing is you have a valid registered domain to use.

You will also, obviously, [need Terraform installed](https://developer.hashicorp.com/terraform/install).

After generating the SSH key and understanding the DNS prerequisite, it's time to choose your cloud provider...

#### Deploy to AWS

- Prerequisites
    - You already have an AWS account
    - You have AWS credentials/profile set locally in your terminal already

- Necessary Variables
    - When executing your terraform commands below, you will be prompted to set some required variables, such as:
        - `public_ssh_key`
    - You can persist these variables so they don't have to be entered manually every time by creating a `terraform.tfvars` file within the `aws/` dir, and putting the value for `public_ssh_key = "PUBLIC_SSH_KEY"` within
    - There are many other variables that can be optionally defined for various purposes. Check `aws/variables.tf` for more info. This is considered an advanced use case, and is out of scope for this general quickstart guide.
        - A quick example: if you want to limit SSH connections to a specific IP address, you can specify `allowed_ssh_ip = "x.x.x.x/32"`

- Deployment Steps
    - `cd` into the `aws/` folder within this repo
    - Run `terraform init`
        - This will generate what's called a state file within the `aws/` folder. This state file is very important, as it's how Terraform tracks the current state of deployed infrastructure.
        - This is appropriate for small, proof-of-concept environments, but I *strongly* encourage you to use a [remote backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) at some point. This environment is pretty small, so it's not a huge deal if the state file gets blown away/corrupted, but it can still be a PITA.
    - Run `terraform apply`
        - You'll see a list of the resources Terraform wants to build and configure. Review it at your own discretion.
        - Enter `yes` to deploy
    - After the Terraform apply operation completes, you'll see a `instance-public-ip` "output" in your terminal. Keep that value somewhere-- it's the public IPv4 address of your evilnginx2 instance, which you'll need throughout the next steps.
    - Even after the terraform apply operation succeeds, the instance will not be *immediately* ready. It's going to install necessary dependencies, build evilnginx2 from source, and so on.
        - I've seen this generally take ~3-5 minutes, but will vary depending on factors like instance type and network conditions.
        - You can track the current progress of the bootstrap scripts by SSHing into the instance and running `tail -f /var/log/cloud-init-output.log`
        - I recommend reloading your current session, either through `source /etc/profile` or logging out then in again via SSH, after the script has completed. There are some necessary PATH modifications that are persisted in `/etc/profile` that won't get picked up if you don't reload your session.
    - Whenever you want, you can SSH into your instance with `ssh -i PATH_TO_PRIVATE_SSH_KEY admin@INSTANCE_PUBLIC_IP`


#### Deploy to Vultr

- Prerequisites
    - You already have a Vultr account
    - You have Vultr API key generated (via Vultr console) and set locally in your terminal

- Necessary Variables
    - When executing your terraform commands below, you will be prompted to set some required variables, such as:
        - `public_ssh_key`
    - You can persist these variables so they don't have to be entered manually every time by creating a `terraform.tfvars` file within the `vultr/` dir, and putting the value for `public_ssh_key = "PUBLIC_SSH_KEY"` within
    - There are many other variables that can be optionally defined for various purposes. Check `vultr/variables.tf` for more info. This is considered an advanced use case, and is out of scope for this general quickstart guide.
        - A quick example: if you want to limit SSH connections to a specific IP address, you can specify `allowed_ssh_ip = "x.x.x.x/32"`

- Deployment Steps
    - `cd` into the `vultr/` folder within this repo
    - Run `terraform init`
        - This will generate what's called a state file within the `vultr/` folder. This state file is very important, as it's how Terraform tracks the current state of deployed infrastructure.
        - This is appropriate for small, proof-of-concept environments, but I *strongly* encourage you to use a [remote backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) at some point. This environment is pretty small, so it's not a huge deal if the state file gets blown away/corrupted, but it can still be a PITA.
    - Run `terraform apply`
        - You'll see a list of the resources Terraform wants to build and configure. Review it at your own discretion.
        - Enter `yes` to deploy
    - After the Terraform apply operation completes, you'll see a `instance-public-ip` "output" in your terminal. Keep that value somewhere-- it's the public IPv4 address of your evilnginx2 instance, which you'll need throughout the next steps.
    - Even after the terraform apply operation succeeds, the instance will not be *immediately* ready. It's going to install necessary dependencies, build evilnginx2 from source, and so on.
        - I've seen this generally take ~3-5 minutes, but will vary depending on factors like instance type and network conditions.
        - You can track the current progress of the bootstrap scripts by SSHing into the instance and running `tail -f /var/log/cloud-init-output.log`
        - I recommend reloading your current session, either through `source /etc/profile` or logging out then in again via SSH, after the script has completed. There are some necessary PATH modifications that are persisted in `/etc/profile` that won't get picked up if you don't reload your session.
    - Whenever you want, you can SSH into your instance with `ssh -i PATH_TO_PRIVATE_SSH_KEY root@INSTANCE_PUBLIC_IP`