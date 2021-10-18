#!/bin/bash
LOCATION="westeurope"
RG_NAME="Management"
SA_NAME="terraformmgnt01" # must be uniq 
SA_SKU="Standard_GRS"   # Premium storage does not support GRS
CONTAINER_NAME="terraform"

az group create --name $RG_NAME --location $LOCATION

az storage account create \
  -n $SA_NAME \
  -g $RG_NAME \
  --location $LOCATION \
  --access-tier Hot \
  --https-only true \
  --kind StorageV2 \
  --sku $SA_SKU \

az storage container create \
  --account-name $SA_NAME \
  --name $CONTAINER_NAME

