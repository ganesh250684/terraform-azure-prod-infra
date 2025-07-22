terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.8.0"
    }
  }

  required_version = ">=1.8.3"
}

provider "azurerm" {
    features {
      
    }
     subscription_id = "f9d2d781-a714-4541-8f5e-96f6744e9e67"
  client_id       = "d0e7ddcd-92a3-47a1-9e20-2765fb680f82"
  client_secret   = "Lg88Q~g6YHk2AzgtkOIG.NL4NafAwJ8ZYXOjSbsE"
  tenant_id       = "132f2762-b9c0-4836-8196-a828efc8136f"
  
}