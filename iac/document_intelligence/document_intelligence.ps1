# *****************************************************************************
#
# File:        document_intelligence.ps1
#
# Description: Creates a Document Intelligence Cognitive Services Account.
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

# Create a Document Intelligence Cognitive Services Account.
Write-Host "Creating a Document Intelligence Cognitive Services Account"

az deployment group create `
  --name "document_intelligence" `
  --resource-group "$resourceGroupName" `
  --template-file "document_intelligence.bicep" `
  --parameters "document_intelligence.parameters.json" `
  --parameters accountName="$documentIntelligenceAccountName" `
               location="$location" `
               privateEndpointName="$documentIntelligencePrivateEndpointName" `
               subnetName="$privateEndpointSubnetName" `
               vnetName="$virtualNetworkName"
               