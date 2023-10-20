// *****************************************************************************
//
// File:        event_grid.bicep
//
// Description: Creates an Event Grid System Topic.
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

@description('The name of the intake Storage Account.')
param intakeStorageAccountName string

@description('The location of the resources.')
param location string = resourceGroup().location

@description('The name of the Event Grid System Topic.')
param systemTopicName string

// Get the intake Storage Account.
resource intakeStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: intakeStorageAccountName
}

// Create a System Topic.
resource systemTopic 'Microsoft.EventGrid/systemTopics@2023-06-01-preview' = {
  name: systemTopicName
  location: location
  properties: {
    source: intakeStorageAccount.id
    topicType: 'Microsoft.Storage.StorageAccounts'
  }
}
