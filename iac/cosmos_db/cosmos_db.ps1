# *****************************************************************************
#
# File:        cosmos_db.ps1
#
# Description: Creates a Cosmos DB Database Account and Database.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# *****************************************************************************

# Get script variables.
. $PSScriptRoot\..\script_variables.ps1

# Create a Cosmos DB Database Account and Database.
Write-Host "Creating a Cosmos DB Database Account and Database"

az deployment group create `
  --name "cosmos_db" `
  --resource-group "$resourceGroupName" `
  --template-file "cosmos_db.bicep" `
  --parameters "cosmos_db.parameters.json" `
  --parameters databaseAccountName="$cosmosDbDatabaseAccountName" `
               location="$location" `
               locationName="$locationName" `
               privateEndpointName="$cosmosDbPrivateEndpointName" `
               subnetName="$privateEndpointSubnetName" `
               vnetName="$virtualNetworkName"