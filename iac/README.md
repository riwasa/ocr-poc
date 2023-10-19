# Infrastructure-as-code files

This folder contains Bicep templates and PowerShell scripts to create Azure resources.

## Prerequisites

PowerShell and Azure CLI need to be installed. These scripts have been tested using Azure CLI 2.53.0 and PowerShell 7.3.8, although the scripts and templates may work on lower versions.

The script_variables.ps1 file should be updated with the following:

- Change $location and $locationName to the region where resources should be deployed. The default value is Canada Central.
- Change $resourceGroupName to the name of the Resource Group where resources should be deployed.
- Change resource names to reflect the company naming convention.

## Execution

Run scripts in the following order, to account for any dependencies between resources.

1. Run virtual_network\virtual_network.ps1 to create a Virtual Network for Function VNet integration and private endpoints.
2. Run document_intelligence\document_intelligence.ps1 to create a Document Intelligence Cognitive Services Account.