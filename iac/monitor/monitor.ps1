# *****************************************************************************
#
# File:        monitor.ps1
#
# Description: Creates a Log Analytics Workspace and an Application Insights
#              Component.
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

# Create a Log Analytics Workspace and an Application Insights Component.
Write-Host "Creating a Log Analytics Workspace and an Application Insights Component"

az deployment group create `
  --name "monitor" `
  --resource-group "$resourceGroupName" `
  --template-file "monitor.bicep" `
  --parameters "monitor.parameters.json" `
  --parameters applicationInsightsComponentName="$applicationInsightsComponentName" `
               logAnalyticsWorkspaceName="$logAnalyticsWorkspaceName"
