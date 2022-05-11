#!/bin/bash

# change according to your environment
# Azure Resources
export AZ_STORAGE_URL="https://azdevopsagentssa.file.core.windows.net/"
export AZ_SMB_PATH="//azdevopsagentssa.file.core.windows.net/azdevopsagentssashare"
export SAG_AZ_SA_NAME="azdevopsagentssa"
export AZ_SM_SHARE_KEY=''

# ACR Service Principal
export AZ_ACR_SP_ID=''
export AZ_ACR_SP_SECRET=''

# ACR login URL
export AZ_ACR_URL=mysagimages.azurecr.io