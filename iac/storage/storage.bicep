// *****************************************************************************
//
// File:        storage.bicep
//
// Description: Creates a Storage Account.
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

@description('The access tier for the Storage Account.')
@allowed([
  'Cool'
  'Hot'
  'Premium'
])
param accessTier string

@description('Indicates if public access is allowed for blobs and containers.')
param allowBlobPublicAccess bool

@description('Indicates if cross-AAD tenant object replication is allowed.')
param allowCrossTenantReplication bool

@description('Indicates if requests can be authorized with the account key.')
param allowSharedKeyAccess bool

@description('The containers to create in the Storage Account.')
param containers array = []

@description('Indicates if OAuth is the default authentication.')
param defaultToOAuthAuthentication bool

@description('The properties for blob soft delete.')
param deleteRetentionPolicy object = {}

@description('The type of DNS endpoint.')
@allowed([
  'AzureDnsZone'
  'Standard'
])
param dnsEndpointType string

@description('The kind of the Storage Account.')
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param kind string

@description('The location of the resources.')
param location string = resourceGroup().location

@description('The minimum TLS version required for requests.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param minimumTlsVersion string

@description('Indicates if public network access is allowed.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string

@description('The name of the SKU.')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
])
param skuName string

@description('The name of the Storage Account.')
param storageAccountName string

// Create a Storage Account.
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: kind
  properties: {
    accessTier: accessTier
    allowBlobPublicAccess: allowBlobPublicAccess
    allowCrossTenantReplication: allowCrossTenantReplication
    allowSharedKeyAccess: allowSharedKeyAccess
    defaultToOAuthAuthentication: defaultToOAuthAuthentication
    dnsEndpointType: dnsEndpointType
    minimumTlsVersion: minimumTlsVersion
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    publicNetworkAccess: publicNetworkAccess
    supportsHttpsTrafficOnly: true
  }
  sku: {
    name: skuName
  }

  resource blobServices 'blobServices' = if (!empty(containers)) {
    name: 'default'
    properties: {
      deleteRetentionPolicy: deleteRetentionPolicy
    }

    resource container 'containers' = [for container in containers: {
      name: container.name
      properties: {
        publicAccess: contains(container, 'publicAccess') ? container.publicAccess : 'None'
      }
    }]
  }
}
