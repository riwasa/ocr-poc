# *****************************************************************************
#
# File:        function.ps1
#
# Description: Creates a Function App.
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

# Create a Function App.
Write-Host "Creating a Function App"

az deployment group create `
  --name "function" `
  --resource-group "$resourceGroupName" `
  --template-file "function.bicep" `
  --parameters "function.parameters.json" `
  --parameters applicationInsightsName="$applicationInsightsComponentName" `
               cosmosDbDatabaseAccountName="$cosmosDbDatabaseAccountName" `
               documentIntelligenceAccountName="$documentIntelligenceAccountName" `
               functionAppName="$functionAppName" `
               functionAppServicePlanName="$functionAppServicePlanName" `
               functionAppStorageName="$functionAppStorageName" `
               location="$location" `
               subnetName="$appServiceSubnetName" `
               vnetName="$virtualNetworkName"
