#!/bin/bash

# Variables - change these as needed
RESOURCE_GROUP_NAME="tfstate-rg"
STORAGE_ACCOUNT_NAME="tfstatestorageprodgk2506" # must be globally unique
CONTAINER_NAME="tfstate"
LOCATION="eastus"

echo "Logging into Azure..."
az login --only-show-errors

echo "Creating resource group: $RESOURCE_GROUP_NAME"
az group create \
  --name "$RESOURCE_GROUP_NAME" \
  --location "$LOCATION"

echo "Creating storage account: $STORAGE_ACCOUNT_NAME"
az storage account create \
  --name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --encryption-services blob

echo "Getting storage account key..."
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --query "[0].value" -o tsv)

echo "Creating blob container: $CONTAINER_NAME"
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --account-key "$ACCOUNT_KEY"

echo "✅ Terraform backend resources created successfully!"
echo "Use the following backend config in your Terraform:"
echo "
terraform {
  backend \"azurerm\" {
    resource_group_name  = \"$RESOURCE_GROUP_NAME\"
    storage_account_name = \"$STORAGE_ACCOUNT_NAME\"
    container_name       = \"$CONTAINER_NAME\"
    key                  = \"terraform.tfstate\"
  }
}
"
