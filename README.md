# 🚀 Terraform & Ansible in Action: Deploying a 2-Tier AWS Architecture (EpicBook)

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)

Welcome to the **EpicBook Deployment Project**! This repository demonstrates a production-style, 2-tier cloud architecture using **Terraform** for Infrastructure as Code (IaC) and **Ansible Roles** for Configuration Management. 

This project completely automates the deployment of a Node.js/MySQL web application (EpicBook) onto AWS, featuring passwordless SSH, dynamic secret injection, and idempotent execution.

---

## 🏗️ Architecture Overview

This project separates the infrastructure from the application logic. 

1. **Tier 1 (Web Server):** An Ubuntu EC2 instance residing in a Public Subnet, serving the Node.js application via an **Nginx Reverse Proxy**.
2. **Tier 2 (Database):** A secure AWS RDS MySQL instance residing in a Private Subnet, completely isolated from direct internet access.

## 🚀 The Tech Stack
* **Cloud Provider:** AWS
* **Infrastructure Provisioning:** Terraform
* **Configuration Management:** Ansible (via Ansible Roles)
* **Application:** Node.js, Express, PM2
* **Web Server:** Nginx
* **Database:** MySQL (AWS RDS)

---

## 📂 Project Structure

This repository follows strict enterprise standards by decoupling infrastructure from configuration:

```text
epicbook-aws-terraform-ansible/
├── terraform/aws/                # Infrastructure as Code (VPC, EC2, RDS, Security Groups)
│   ├── main.tf                   # Core AWS resources (Networking, Compute, Database)
│   ├── ansible_integration.tf    # The Bridge: Auto-generates Ansible inventory & variables
│   ├── providers.tf              # AWS and Local provider configurations
│   ├── variables.tf              # Customizable input variables
│   ├── outputs.tf                # Public IP and DB endpoints
│   └── .terraform.lock.hcl       # Dependency lock file for Terraform providers
│
└── ansible/                      # Configuration Management (Software, App, DB Seeding)
    ├── site.yml                  # The Master Playbook (Orchestrator)
    └── roles/                    # Modular Ansible blocks
        ├── common/               # Installs baseline tools (git, curl, unzip)
        ├── nginx/                # Configures Nginx as a reverse proxy
        └── epicbook/             # Clones app, injects secrets, seeds DB, starts PM2
```
## ⚠️ Prerequisites (Read Before Running)

To run this project seamlessly on your local machine, you must have the following installed:

* **Operating System:** Linux, macOS, or **Windows Subsystem for Linux (WSL)**. *(Note: Ansible does not run natively on Windows Command Prompt or PowerShell).*
* **[AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html):** Installed and configured with your credentials (aws configure).
* **[Terraform](https://developer.hashicorp.com/terraform/downloads):** Installed and added to your system PATH.
* **[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html):** Installed on your system. You can install it globally via your package manager (e.g., `sudo apt install ansible`) or via `pipx` (`pipx install ansible`).

  (Note: If you are using standard `pip`, it is highly recommended to install it inside an active Python virtual environment).
* **SSH Key Pair:** You must have an ED25519 SSH key generated on your local machine. Terraform will automatically upload this key to AWS for passwordless access.
  
   * If you don't have one, generate it by running: `ssh-keygen -t ed25519 -C "your_email@example.com"` (press Enter to accept default locations).

---

## 🚀 Step-by-Step Deployment Guide

### Phase 1: Provision the Infrastructure
We use Terraform to build the physical servers and networks. 

*Magic Feature:* At the end of provisioning, Terraform dynamically generates your Ansible `inventory.ini` and `group_vars/web.yml` files for you using the newly created infrastructure outputs.

  1. Navigate to the Terraform directory:
```bash
cd terraform/aws
```
  2. Initialize Terraform to download the necessary AWS and Local providers:
```bash
terraform init
```
  3. Export your secure database password as an environment variable (Terraform automatically reads variables prefixed with `TF_VAR_`):
```bash
export TF_VAR_db_password="YourSecurePassword123!"
```
  4. Preview the infrastructure that will be created:
```bash
terraform plan
```
  5. Build the infrastructure:
```bash
terraform apply -auto-approve
```
   Wait 3-5 minutes for the RDS database to fully provision.

### Phase 2: Configure the Servers
Now that the bare-metal servers are running, we use Ansible to install the software, inject our database secrets, and start the application.

  1. Navigate to the Ansible directory:
```bash
cd ../../ansible
```
  2. Run the master playbook. (Note: We use -o StrictHostKeyChecking=no in our auto-generated inventory to bypass manual SSH prompts).
```bash
ansible-playbook -i inventory.ini site.yml
 ```
### Phase 3: Verify the Deployment

  1. Open your terminal and run `terraform output public_ip` (from the `terraform/aws` folder) to get your server's IP address.
  2. Paste that IP address into your web browser: `http://<YOUR_PUBLIC_IP>`
  3. You should see the EpicBook application live, with books dynamically loaded from the secure RDS database!

---

## Clean Up (Save Your Cloud Credits)
To avoid being billed for resources when you are done testing, destroy the infrastructure.

Navigate back to the Terraform folder and run:
```bash
cd terraform/aws
terraform destroy -auto-approve
```
## 🧠 Advanced Concepts Implemented
- **Zero-Touch SSH:** Instead of manually downloading .pem files, Terraform reads your local public SSH key and injects it directly into the EC2 instance upon creation.

- **Jinja2 Secret Injection:** Database passwords are never hardcoded into the application code. Ansible uses Jinja2 templates (.j2) to dynamically inject secrets into the config.json file directly on the server.

- **Database Idempotency:** The Ansible playbook is fully idempotent. It uses the mysql CLI to check if the database exists. If it does, it gracefully skips the seeding tasks to prevent data corruption.

- **Ansible Handlers:** Nginx is only reloaded if its configuration file actually changes, preventing unnecessary downtime.

## ⚡ Quick Start

```
git clone ...
cd terraform/aws
terraform apply -auto-approve
cd ../../ansible
ansible-playbook -i inventory.ini site.yml
```

## 📌 Author

Built with 💻 by [Pratyush Pahari](https://github.com/paharipratyush)

Developed as part of the DevOps Micro Internship (DMI) Cohort 2.

Feel free to ⭐ the repo if you found it useful!
