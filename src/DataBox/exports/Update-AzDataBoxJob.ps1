
# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Updates the properties of an existing job.
.Description
Updates the properties of an existing job.
.Example
PS C:\>  $keyEncryptionDetails = New-AzDataBoxKeyEncryptionKeyObject -KekType "CustomerManaged" -IdentityProperty @{Type = "UserAssigned"; UserAssignedResourceId = "/subscriptions/SubscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identityName"} -KekUrl "keyIdentifier" -KekVaultResourceId "/subscriptions/SubscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.KeyVault/vaults/keyVaultName"

PS C:\> $keyEncryptionDetails

KekType         KekUrl                                           KekVaultResourceId
-------         ------                                           ------------------
CustomerManaged keyIdentifier /subscriptions/SubscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.KeyVault/vaults/keyVaultName

PS C:\> Update-AzDataBoxJob -Name "powershell10" -ResourceGroupName "resourceGroupName" -KeyEncryptionKey $keyEncryptionDetails -ContactDetail $contactDetail -ShippingAddress $ShippingDetails  -IdentityType "UserAssigned" -UserAssignedIdentity @{"/subscriptions/SubscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identityName" = @{}}

Name         Location Status        TransferType  SkuName IdentityType DeliveryType Detail
----         -------- ------        ------------  ------- ------------ ------------ ------
Powershell10 WestUS   DeviceOrdered ImportToAzure DataBox UserAssigned NonScheduled Microsoft.Azure.PowerShell.Cmdlets.DataBox.Models.Api20210301.DataBoxJobDetails
.Example
PS C:\>   $databoxUpdate = Update-AzDataBoxJob -Name "pwshTestSAssigned" -ResourceGroupName "resourceGroupName" -ContactDetail $contactDetail -ShippingAddress $ShippingDetails  -IdentityType "SystemAssigned"

PS C:\> $databoxUpdate.Identity

PrincipalId                          TenantId                             Type
-----------                          --------                             ----
920850f5-9b6b-4017-a81a-3dcafe348be7 72f988bf-86f1-41af-91ab-2d7cd011db47 SystemAssigned

PS C:\> $keyEncryptionDetails = New-AzDataBoxKeyEncryptionKeyObject -KekType "CustomerManaged" -IdentityProperty @{Type = "SystemAssigned"} -KekUrl "keyIdentifier" -KekVaultResourceId "/subscriptions/SubscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.KeyVault/vaults/keyVaultName"

PS C:\> $databoxUpdateWithCMK = Update-AzDataBoxJob -Name "pwshTestSAssigned" -ResourceGroupName "resourceGroupName" -ContactDetail $contactDetail -ShippingAddress $ShippingDetails  -KeyEncryptionKey $keyEncryptionDetails

PS C:\> $databoxUpdateWithCMK.Identity

PrincipalId                          TenantId                             Type
-----------                          --------                             ----
920850f5-9b6b-4017-a81a-3dcafe348be7 72f988bf-86f1-41af-91ab-2d7cd011db47 SystemAssigned

PS C:\> $databoxUpdateWithCMK.Detail.KeyEncryptionKey

KekType         KekUrl                                           KekVaultResourceId
-------         ------                                           ------------------
CustomerManaged keyIdentifier /subscriptions/SubscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.KeyVault/vaults/keyVaultName
.Example
PS C:\>   $keyEncryptionDetails = New-AzDataBoxKeyEncryptionKeyObject -KekType "CustomerManaged" -IdentityProperty @{Type = "UserAssigned"; UserAssignedResourceId = "/subscriptions/SubscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identityName"} -KekUrl "keyIdentifier" -KekVaultResourceId "/subscriptions/SubscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.KeyVault/vaults/keyVaultName"
PS C:\>  $updateSystemToUserAssigned = Update-AzDataBoxJob -Name "pwshTestSAssigned" -ResourceGroupName "resourceGroupName" -KeyEncryptionKey $keyEncryptionDetails -ContactDetail $contactDetail -ShippingAddress $ShippingDetails  -IdentityType "SystemAssigned,UserAssigned" -IdentityUserAssignedIdentity @{"/subscriptions/SubscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identityName" = @{}}

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.DataBox.Models.Api20210301.IJobResource
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

CONTACTDETAIL <IContactDetails>: Contact details for notification and shipping.
  ContactName <String>: Contact name of the person.
  EmailList <String[]>: List of Email-ids to be notified about job progress.
  Phone <String>: Phone number of the contact person.
  [Mobile <String>]: Mobile number of the contact person.
  [NotificationPreference <INotificationPreference[]>]: Notification preference for a job stage.
    SendNotification <Boolean>: Notification is required or not.
    StageName <NotificationStageName>: Name of the stage.
  [PhoneExtension <String>]: Phone extension number of the contact person.

KEYENCRYPTIONKEY <IKeyEncryptionKey>: Key encryption key for the job.
  KekType <KekType>: Type of encryption key used for key encryption.
  [IdentityProperty <IIdentityProperties>]: Managed identity properties used for key encryption.
    [Type <String>]: Managed service identity type.
    [UserAssignedResourceId <String>]: Arm resource id for user assigned identity to be used to fetch MSI token.
  [KekUrl <String>]: Key encryption key. It is required in case of Customer managed KekType.
  [KekVaultResourceId <String>]: Kek vault resource id. It is required in case of Customer managed KekType.

SHIPPINGADDRESS <IShippingAddress>: Shipping address of the customer.
  Country <String>: Name of the Country.
  StreetAddress1 <String>: Street Address line 1.
  [AddressType <AddressType?>]: Type of address.
  [City <String>]: Name of the City.
  [CompanyName <String>]: Name of the company.
  [PostalCode <String>]: Postal code.
  [StateOrProvince <String>]: Name of the State or Province.
  [StreetAddress2 <String>]: Street Address line 2.
  [StreetAddress3 <String>]: Street Address line 3.
  [ZipExtendedCode <String>]: Extended Zip Code.
.Link
https://docs.microsoft.com/powershell/module/az.databox/update-azdataboxjob
#>
function Update-AzDataBoxJob {
[OutputType([Microsoft.Azure.PowerShell.Cmdlets.DataBox.Models.Api20210301.IJobResource])]
[CmdletBinding(DefaultParameterSetName='UpdateExpanded', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
param(
    [Parameter(Mandatory)]
    [Alias('JobName')]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Path')]
    [System.String]
    # The name of the job Resource within the specified resource group.
    # job names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
    ${Name},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Path')]
    [System.String]
    # The Resource Group Name
    ${ResourceGroupName},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Path')]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
    [System.String]
    # The Subscription Id
    ${SubscriptionId},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Header')]
    [System.String]
    # Defines the If-Match condition.
    # The patch will be performed only if the ETag of the job on the server matches this value.
    ${IfMatch},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Models.Api20210301.IContactDetails]
    # Contact details for notification and shipping.
    # To construct, see NOTES section for CONTACTDETAIL properties and create a hash table.
    ${ContactDetail},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Body')]
    [System.String]
    # Identity type
    ${IdentityType},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Models.Api20210301.IKeyEncryptionKey]
    # Key encryption key for the job.
    # To construct, see NOTES section for KEYENCRYPTIONKEY properties and create a hash table.
    ${KeyEncryptionKey},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Models.Api20210301.IShippingAddress]
    # Shipping address of the customer.
    # To construct, see NOTES section for SHIPPINGADDRESS properties and create a hash table.
    ${ShippingAddress},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.DataBox.Models.Api20210301.IJobResourceUpdateParameterTags]))]
    [System.Collections.Hashtable]
    # The list of key value pairs that describe the resource.
    # These tags can be used in viewing and grouping this resource (across resource groups).
    ${Tag},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.DataBox.Models.Api20210301.IResourceIdentityUserAssignedIdentities]))]
    [System.Collections.Hashtable]
    # User Assigned Identities
    ${UserAssignedIdentity},

    [Parameter()]
    [Alias('AzureRMContext', 'AzureCredential')]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Azure')]
    [System.Management.Automation.PSObject]
    # The credentials, account, tenant, and subscription used for communication with Azure.
    ${DefaultProfile},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Run the command as a job
    ${AsJob},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Wait for .NET debugger to attach
    ${Break},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be appended to the front of the pipeline
    ${HttpPipelineAppend},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be prepended to the front of the pipeline
    ${HttpPipelinePrepend},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Run the command asynchronously
    ${NoWait},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Runtime')]
    [System.Uri]
    # The URI for the proxy server to use
    ${Proxy},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Runtime')]
    [System.Management.Automation.PSCredential]
    # Credentials for a proxy server to use for the remote call
    ${ProxyCredential},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Use the default credentials for the proxy
    ${ProxyUseDefaultCredentials}
)

begin {
    try {
        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
            $PSBoundParameters['OutBuffer'] = 1
        }
        $parameterSet = $PSCmdlet.ParameterSetName
        $mapping = @{
            UpdateExpanded = 'Az.DataBox.private\Update-AzDataBoxJob_UpdateExpanded';
        }
        if (('UpdateExpanded') -contains $parameterSet -and -not $PSBoundParameters.ContainsKey('SubscriptionId')) {
            $PSBoundParameters['SubscriptionId'] = (Get-AzContext).Subscription.Id
        }
        $cmdInfo = Get-Command -Name $mapping[$parameterSet]
        [Microsoft.Azure.PowerShell.Cmdlets.DataBox.Runtime.MessageAttributeHelper]::ProcessCustomAttributesAtRuntime($cmdInfo, $MyInvocation, $parameterSet, $PSCmdlet)
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand(($mapping[$parameterSet]), [System.Management.Automation.CommandTypes]::Cmdlet)
        $scriptCmd = {& $wrappedCmd @PSBoundParameters}
        $steppablePipeline = $scriptCmd.GetSteppablePipeline($MyInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
    } catch {
        throw
    }
}

process {
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
}

end {
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
}
}
