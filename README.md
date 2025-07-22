# terraform-azure-prod-infra
Production-like Azure environment using HashiCorp Terraform by Ganesh Kumbhar

# 🚀 Terraform Azure Production-Like Environment

This repository contains Infrastructure as Code (IaC) scripts using **HashiCorp Terraform** to provision a **production-like Azure environment**, including networking, compute, storage, databases, and security components.

---

## 🏗️ Architecture Overview

> Phase 1 (Week 1): Network Foundation – Hub and Spoke Architecture


✅ Peering between Hub and Spoke  
✅ Subnets, NSGs, and Routing setup  
✅ Bastion for secure VM access

> Future phases will add: Azure VMs, Firewall, Load Balancer, SQL DB, Key Vault, Monitoring, and CI/CD.

---

## 🗂️ Folder Structure

terraform-azure-prod-infra/
├── dev/ # Development environment configs
├── prod/ # Production environment configs
├── modules/ # Reusable Terraform modules
│ └── network/ # Hub-Spoke network setup
├── shared/ # Shared components (e.g., backend, keyvault)
├── README.md # This file



---

## ✅ Week 1 - Task 1: Setup GitHub Repo and Base Structure

### 🎯 Goal
Set up the project foundation to manage infrastructure using modular and production-grade standards.

### 🔧 Actions Taken

1. **Created GitHub Repository**
   - `terraform-azure-prod-infra` initialized with a `.gitignore` and `README.md`.
            ✅ Step 1: Create GitHub Repository
                Go to https://github.com

                Click on “New Repository”

                Set:

                Repository Name: terraform-azure-prod-infra

                Description: Production-like Azure environment using HashiCorp Terraform
                Add .gitignore → Select Terraform

                Add README.md

                Click Create Repository

2. **Cloned Locally**
   ```bash
   git clone https://github.com/ganesh250684/terraform-azure-prod-infra.git
   cd terraform-azure-prod-infra

   Created Folder Structure

bash
Copy
Edit
mkdir -p modules/network dev prod shared
Created Backend Config (dev/backend.tf)

hcl
Copy
Edit
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestorageprod"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
Created Variables and Provider
dev/variables.tf

h
Copy
Edit
variable "location" {
  default = "eastus"
}

variable "env" {
  default = "dev"
}
dev/providers.tf

hcl
Copy
Edit
provider "azurerm" {
  features {}
}
Committed and Pushed to GitHub

bash
Copy
Edit
git add .
git commit -m "Initial structure with backend and provider setup"
git push origin main
📦 Next Steps
Week 1 - Task 2: Implement Hub-Spoke Virtual Networks using modules.

Week 2: Deploy Azure VMs, NSGs, Bastion Host.

Week 3: Add Firewall, SQL DB, Monitoring.

Week 4: Add CI/CD using GitHub Actions, Workspaces, and Policies.




####################
✅ Step-by-Step Action Plan
📁 Week 1: Project Setup and Networking
Setup GitHub Repo

Repo name: terraform-azure-prod-infra

Create folders: network, compute, security, database, monitoring, main

Create Backend for Terraform

Use Azure Storage Account for remote state

Configure backend in main.tf

Networking (Hub-Spoke Architecture)

Create hub VNet and spoke VNet

Add peering between them

Create subnets: app, db, bastion

Associate NSGs with each subnet

📁 Week 2: Compute, Security & Database
Virtual Machines Setup

Use azurerm_linux_virtual_machine for app tier

Use azurerm_windows_virtual_machine for database tier

Use Key Vault for storing admin passwords

Bastion Host

Setup Azure Bastion for secure VM access

Database Layer

Use Azure SQL Server or MySQL

Place inside DB subnet

Enable private endpoint

NSGs and Route Tables

Write detailed rules (deny internet from DB, allow App to DB, etc.)

📁 Week 3: Security, Monitoring, and Gateway
Key Vault + RBAC

Create secrets for VM creds

Assign roles to users/principals

Firewall / Application Gateway

Deploy Azure Firewall (or App Gateway with WAF)

Create custom routes to force traffic via firewall

Monitoring

Setup Log Analytics Workspace

Enable diagnostics for resources

📁 Week 4: Final Touches & Automation
Terraform Modules

Refactor your code into reusable modules:

network, vm, sql, bastion, keyvault, monitoring, firewall

Automation

Add GitHub Actions or Azure DevOps Pipeline to run terraform plan/apply

Use terraform validate and tflint for quality

README.md


👨‍💻 Author
Ganesh Kumbhar
Terraform | Azure | DevOps | IaC Practitioner
LinkedIn | YouTube