# *****************************************************************************
#
# File:        script_variables.ps1
#
# Description: Sets variables used in other scripts.
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

# ***********************************************
# Global values.
# ***********************************************

# Azure region. The location name is used for Cosmos DB.
$location = "canadacentral"
$locationName = "Canada Central"

# Resource Group name.
$resourceGroupName = "ll-ocr-poc-rg"

# ***********************************************
# Resource values.
# ***********************************************

# Cosmos DB.
$cosmosDbDatabaseAccountName = "ll-ocr-poc-cosmos"
$cosmosDbPrivateEndpointName = "ll-ocr-poc-cosmos-pe"

# Document Intelligence.
$documentIntelligenceAccountName = "ll-ocr-poc-docint"
$documentIntelligencePrivateEndpointName = "ll-ocr-poc-docint-pe"

# Function.
$functionAppName = "ll-ocr-poc-func"
$functionAppServicePlanName = "ll-ocr-poc-func-asp"
$functionAppStorageName = "llocrpocfuncst"

# Monitor.
$applicationInsightsComponentName = "ll-ocr-poc-appi"
$logAnalyticsWorkspaceName = "ll-ocr-poc-law"

# Storage.
$intakeStorageAccountName = "llocrpocintakest"

# Virtual Network. Do not change the subnet names without also changing them
# in virtual_network\virtual_network.parameters.json.
$appServiceSubnetName = "app-service"
$privateEndpointSubnetName = "private-endpoints"
$virtualNetworkName = "ll-ocr-poc-vnet"