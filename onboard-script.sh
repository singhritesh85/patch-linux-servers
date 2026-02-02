#!/bin/bash

# Add the service principal application ID and secret here
ServicePrincipalId="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
ServicePrincipalClientSecret="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

export subscriptionId="5XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX ";
export resourceGroup="azure-arc";
export tenantId="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX ";
export location="eastus2";
export authType="principal";
export correlationId="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX ";
export cloud="AzureCloud";

# Download the installation package
LINUX_INSTALL_SCRIPT="/tmp/install_linux_azcmagent.sh"
if [ -f "$LINUX_INSTALL_SCRIPT" ]; then rm -f "$LINUX_INSTALL_SCRIPT"; fi;
output=$(wget https://gbl.his.arc.azure.com/azcmagent-linux -O "$LINUX_INSTALL_SCRIPT" 2>&1);
if [ $? != 0 ]; then wget -qO- --method=PUT --body-data="{\"subscriptionId\":\"$subscriptionId\",\"resourceGroup\":\"$resourceGroup\",\"tenantId\":\"$tenantId\",\"location\":\"$location\",\"correlationId\":\"$correlationId\",\"authType\":\"$authType\",\"operation\":\"onboarding\",\"messageType\":\"DownloadScriptFailed\",\"message\":\"$output\"}" "https://gbl.his.arc.azure.com/log" &> /dev/null || true; fi;
echo "$output";

# Install the hybrid agent
bash "$LINUX_INSTALL_SCRIPT";
sleep 5;

# Run connect command
sudo azcmagent connect --service-principal-id "$ServicePrincipalId" --service-principal-secret "$ServicePrincipalClientSecret" --resource-group "$resourceGroup" --tenant-id "$tenantId" --location "$location" --subscription-id "$subscriptionId" --cloud "$cloud" --tags 'ArcSQLServerExtensionDeployment=Disabled' --correlation-id "$correlationId" --tags "Environment=Managed-VM,Project=Dexter,patch=scheduled";
