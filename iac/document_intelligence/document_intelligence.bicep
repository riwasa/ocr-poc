// *****************************************************************************
//
// File:        document_intelligence.bicep
//
// Description: Creates a Document Intelligence Cognitive Services Account.
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

@description('The name of the Document Intelligence Account.')
@minLength(2)
@maxLength(64)
param accountName string

@description('The location of the resources.')
param location string = resourceGroup().location

@description('The name of the private endpoint.')
param privateEndpointName string

@description('Indicates whether public endpoint access is allowed.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string

@description('The name of the SKU.')
@allowed([
  'S0'
])
param skuName string = 'S0'

@description('The name of the subnet for private endpoints.')
param subnetName string

@description('The name of the Virtual Network.')
param vnetName string

// Create a Document Intelligence Cognitive Services Account.
resource documentIntelligenceAccount 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: accountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'FormRecognizer'
  properties: {
    customSubDomainName: accountName
    networkAcls: {
      defaultAction: 'Deny'
    }
    publicNetworkAccess: publicNetworkAccess
  }
  sku: {
    name: skuName
  }
}

// Create a private DNS zone.
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.cognitiveservices.azure.com'
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
            'account'
          ]
          privateLinkServiceId: documentIntelligenceAccount.id
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
    registrationEnabled: true
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
        name: 'privatelink-cognitiveservices'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }  
}
