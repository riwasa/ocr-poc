// *****************************************************************************
//
// File:        monitor.bicep
//
// Description: Creates a Log Analytics Workspace and an Application Insights
//              Component.
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

@description('The name of the Application Insights Component.')
param applicationInsightsComponentName string

@description('The kind of application that this component refers to, used to customize UI.')
@allowed([
  'ios'
  'java'
  'other'
  'phone'
  'store'
  'web'
])
param applicationInsightsKind string

@description('The retention period in days.')
@allowed([
  30
  60
  90
  120
  180
  270
  365
  550
  730
])
param applicationInsightsRetentionInDays int

@description('The type of application being monitored.')
@allowed([
  'other'
  'web'
])
param applicationType string

@description('The daily volume cap for ingestion.')
@minValue(-1)
param dailyQuotaGb int = -1

@description('Indicates which permission to use - resource or workspace or both.')
param enableLogAccessUsingOnlyResourcePermissions bool

@description('The location of the resources.')
param location string = resourceGroup().location

@description('The retention period in days.')
@allowed([
  30
  60
  90
  120
  180
  270
  365
  550
  730
])
param logAnalyticsRetentionInDays int

@description('The name of the Log Analytics Workspace.')
@minLength(4)
@maxLength(63)
param logAnalyticsWorkspaceName string

@description('The network access type for accessing ingestion.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccessForIngestion string

@description('The network access type for accessing query.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccessForQuery string

// Create a Log Analytics Workspace.
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    features: {
      enableLogAccessUsingOnlyResourcePermissions: enableLogAccessUsingOnlyResourcePermissions
    }
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    retentionInDays: logAnalyticsRetentionInDays
    sku: {
      name: 'PerGB2018'
    }
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }    
  }
}

// Create an Application Insights Component.
resource applicationInsightsComponent 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsComponentName
  location: location
  kind: applicationInsightsKind
  properties:{
    Application_Type: applicationType
    Flow_Type: 'Bluefield'
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    Request_Source: 'rest'
    RetentionInDays: applicationInsightsRetentionInDays
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}
