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

    mkdir -p modules/network dev prod shared

    Created Backend Config (dev/backend.tf)

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

variable "location" {
  default = "eastus"
}

variable "env" {
  default = "dev"
}
dev/providers.tf

provider "azurerm" {
  features {}
}
Committed and Pushed to GitHub
git add .
git commit -m "Initial structure with backend and provider setup"
git push origin main

📦 Next Steps
###Week 1 - Task 2: Implement Hub-Spoke Virtual Networks using modules.

###Week 2: Deploy Azure VMs, NSGs, Bastion Host.

###Week 3: Add Firewall, SQL DB, Monitoring.

###Week 4: Add CI/CD using GitHub Actions, Workspaces, and Policies.




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


#########################

# Terraform Task 2: Create Hub and Spoke Virtual Networks with Peering in Azure

This task focuses on creating a hub-and-spoke network architecture on Azure using Terraform modules. You will create two virtual networks (VNets), `hub-vnet` and `spoke-vnet`, each with their own subnets, and establish peering between them.

---

## Task Objectives

- Create two VNets: Hub and Spoke with distinct address spaces.
- Create subnets inside each VNet based on provided CIDR blocks.
- Peer the VNets to allow traffic forwarding and communication.
- Use Terraform modules for reusable and clean infrastructure code.
- Use variables and outputs effectively for flexibility.

---

## Step-by-Step Instructions

### 1. Define the Network Module

Inside your Terraform project, create a module folder (e.g., `modules/network`) that contains the following files:

#### a. `modules/network/variables.tf`

```hcl
variable "vnet_name" {
  type = string
  description = "Name of the Virtual Network"
}

variable "address_space" {
  type = list(string)
  description = "Address space for the Virtual Network"
}

variable "location" {
  type = string
  description = "Azure region where resources will be created"
}

variable "resource_group_name" {
  type = string
  description = "Name of the resource group"
}

variable "subnets" {
  type = map(string)
  description = "Map of subnet names to address prefixes"
}
````

#### b. `modules/network/main.tf`

```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnets" {
  for_each            = var.subnets
  name                = each.key
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [each.value]
}
```

#### c. `modules/network/outputs.tf`

```hcl
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  value = { for name, subnet in azurerm_subnet.subnets : name => subnet.id }
}
```

---

### 2. Configure Root Module to Call Network Module and Define Peering

In your root module folder (e.g., `dev/` or root), create or update `main.tf` with the following content:

```hcl
module "hub_vnet" {
  source              = "../modules/network"
  vnet_name           = "hub-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name

  subnets = {
    bastion = "10.0.0.0/24"
  }
}

module "spoke_vnet" {
  source              = "../modules/network"
  vnet_name           = "spoke-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name

  subnets = {
    app = "10.1.1.0/24"
    db  = "10.1.2.0/24"
  }
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = module.hub_vnet.vnet_name
  remote_virtual_network_id = module.spoke_vnet.vnet_id

  allow_forwarded_traffic       = true
  allow_virtual_network_access  = true
  allow_gateway_transit         = false
  use_remote_gateways           = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = module.spoke_vnet.vnet_name
  remote_virtual_network_id = module.hub_vnet.vnet_id

  allow_forwarded_traffic       = true
  allow_virtual_network_access  = true
  allow_gateway_transit         = false
  use_remote_gateways           = false
}
```

---

### 3. Define Variables in Root Module

Create a `variables.tf` file in the root folder with:

```hcl
variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Azure Resource Group Name"
  type        = string
  default     = "rg-networking"
}
```

---

### 4. Create a `.tfvars` File for Dev Environment

Create `dev.tfvars` with:

```hcl
location            = "eastus"
resource_group_name = "rg-networking"
```

---

### 5. Initialize, Plan, and Apply

Run the following commands in your root module directory:

```bash
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

---

## Summary

*  built a reusable Terraform module for VNets and subnets.
*  deployed hub and spoke VNets with distinct address spaces.
*  created VNet peering to allow communication between them.
*  used variables and `.tfvars` files to parameterize your deployment.
*  practiced modular infrastructure as code for scalable management.

---

### Helpful Links

* [Terraform AzureRM Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [Azure Virtual Network Peering](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)
* [Terraform Modules](https://www.terraform.io/language/modules)

---

Feel free to ask questions or open issues if anything is unclear!

---

**Happy Terraforming!** 🚀


