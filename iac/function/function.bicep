// *****************************************************************************
//
// File:        function.bicep
//
// Description: Creates a Function App.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// *****************************************************************************

@description('The name of the Storage Account for the Function App.')
param functionAppStorageName string

@description('Indicates if the Function App should not be unloaded when idle.')
param alwaysOn bool

@description('The name of the Application Insights Component.')
param applicationInsightsName string

@description('Indicates if session affinity cookies should be sent.')
param clientAffinityEnabled bool

@description('The name of the Cosmos DB Database Account.')
param cosmosDbDatabaseAccountName string

@description('The name of the Document Intelligence Cognitive Services Account.')
param documentIntelligenceAccountName string

@description('Indicates if FTPS is allowed.')
@allowed([
  'AllAllowed'
  'Disabled'
  'FtpsOnly'
])
param ftpsState string

@description('The name of the Function App.')
param functionAppName string

@description('The name of the App Service Plan for the Function App.')
param functionAppServicePlanName string

@description('The location of the resources.')
param location string = resourceGroup().location

@description('The .NET Framework version.')
param netFrameworkVersion string

@description('Indicates if apps assigned to this App Service plan can be scaled independently.')
param perSiteScaling bool = false

@description('Indicates if public traffic is allowed.')
@allowed([
  'Disabled'
  'Enabled'
  ''
])
param publicNetworkAccess string

@description('Server OS.')
@allowed([
  'Linux'
  'Windows'
])
param serverOS string = 'Windows'

@description('The number of instances.')
param skuCapacity int

@description('The name of the App Service Plan SKU.')
param skuName string

@description('The pricing tier of the App Service Plan.')
param skuTier string

@description('The name of the subnet for VNet integration.')
param subnetName string

@description('Indicates if the App Service Plan will use a 32-bit worker process.')
param use32BitWorkerProcess bool

@description('The name of the Virtual Network.')
param vnetName string

@description('Indicates if all outbound traffic should be routed through the integrated VNet.')
param vnetRouteAllEnabled bool

@description('Indicates if the App Service Plan will perform Availability Zone balancing.')
param zoneRedundant bool = false

// Get the Application Insights Component.
resource applicationInsightsComponent 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

// Get the Cosmos DB Database Account.
resource cosmosDbDatabaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-09-15' existing = {
  name: cosmosDbDatabaseAccountName
}

// Get the Document Intelligence Cognitive Services Account.
resource documentIntelligence 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: documentIntelligenceAccountName
}

// Get the subnet for VNet integration.
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' existing = {
  name: '${vnetName}/${subnetName}'
}

// Create an App Service Plan.
resource functionAppServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: functionAppServicePlanName
  location: location
  kind: serverOS == 'Windows' ? '' : 'linux'
  properties: {
    perSiteScaling: perSiteScaling
    reserved: serverOS == 'Linux'
    zoneRedundant: zoneRedundant
  }
  sku: {
    capacity: skuCapacity
    name: skuName
    tier: skuTier
  }
}

// Create a Storage Account.
resource functionAppStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: functionAppStorageName
  location: location
  kind: 'StorageV2'
  properties: {
    defaultToOAuthAuthentication: true
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
  sku: {
    name: 'Standard_LRS'
  }
}

// Create a Function App.
resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    clientAffinityEnabled: clientAffinityEnabled
    httpsOnly: true
    publicNetworkAccess: publicNetworkAccess
    serverFarmId: functionAppServicePlan.id
    siteConfig: {
      alwaysOn: alwaysOn
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsightsComponent.properties.ConnectionString
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionAppStorageName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${functionAppStorageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'CosmosDB'
          value: cosmosDbDatabaseAccount.listConnectionStrings().connectionStrings[0].connectionString
        }
        {
          name: 'DocumentIntelligenceEndpoint'
          value: documentIntelligence.properties.endpoint
        }
        {
          name: 'DocumentIntelligenceKey'
          value: documentIntelligence.listKeys().key1
        }
        {
          name: 'ModelType'
          value: 'GeneralDocument'
        }
      ]
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
      }
      ftpsState: ftpsState
      ipSecurityRestrictions: [
        {
          action: 'Allow'
          ipAddress: 'AzureEventGrid'
          name: 'Allow Event Grid'
          priority: 100
          tag: 'ServiceTag'
        }
        {
          action: 'Deny'
          ipAddress: 'Any'
          name: 'Deny All'
          priority: 2147483647
        }
      ]
      ipSecurityRestrictionsDefaultAction: 'Deny'
      netFrameworkVersion: netFrameworkVersion
      scmIpSecurityRestrictions: [
        {
          action: 'Deny'
          ipAddress: 'Any'
          name: 'Deny All'
          priority: 2147483647
        }
      ]
      scmIpSecurityRestrictionsDefaultAction: 'Deny'
      scmIpSecurityRestrictionsUseMain: false
      use32BitWorkerProcess: use32BitWorkerProcess
      vnetRouteAllEnabled: vnetRouteAllEnabled
    }
    virtualNetworkSubnetId: subnet.id
  }
}
