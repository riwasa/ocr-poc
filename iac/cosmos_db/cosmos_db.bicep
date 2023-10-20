// *****************************************************************************
//
// File:        cosmos_db.bicep
//
// Description: Creates a Cosmos DB Database Account and Database.
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

@description('The name of the Database Account.')
@minLength(3)
@maxLength(44)
param databaseAccountName string

@description('The location of the resources.')
param location string

@description('The name of the location of the resources.')
param locationName string

@description('The name of the private endpoint.')
param privateEndpointName string

@description('Indicates whether public access to the account is allowed.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string

@description('The name of the subnet for private endpoints.')
param subnetName string

@description('The name of the Virtual Network.')
param vnetName string

// Create a Cosmos DB Database Account.
resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-09-15' = {
  name: databaseAccountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    backupPolicy: {
      type: 'Continuous'
    }
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
    enableFreeTier: false
    locations: [
      {
        failoverPriority: 0
        locationName: locationName
      }
    ]
    publicNetworkAccess: publicNetworkAccess
  }
  tags: {
    defaultExperience: 'Core (SQL)'
  }
}

// Create a private DNS zone.
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.documents.azure.com'
  location: 'global'
}

// Create a private endpoint.
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: privateEndpointName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          groupIds: [
            'Sql'
          ]
          privateLinkServiceId: databaseAccount.id
        }
      }
    ]
    subnet: {
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
    }
  }
}

// Create a virtual network link.
resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${vnetName}-link'
  location: 'global'
  parent: privateDnsZone
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetName)
    }
  }
}

// Create a private DNS zone group.
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = {
  name: 'default'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-documents-azure-com'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }  
}

// Create a Cosmos DB Database.
resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-09-15' = {
  name: 'ocrPoc'
  parent: databaseAccount
  properties: {
    resource: {
      id: 'ocrPoc'
    }
  }
}

// Create a Cosmos DB container for forms processed using the pre-defined general document model.
resource formTypesContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-09-15' = {
  name: 'generalModel'
  parent: database
  properties: {
    resource: {
      id: 'generalModel'
      partitionKey: {
        kind: 'Hash'
        paths: [
          '/id'
        ]
      }
    }
  }
}

// Create a Cosmos DB container for forms processed using custom models.
resource patientFormsContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-09-15' = {
  name: 'customModel'
  parent: database
  properties: {
    resource: {
      id: 'customModel'
      partitionKey: {
        kind: 'Hash'
        paths: [
          '/id'
        ]
      }
    }
  }
}
