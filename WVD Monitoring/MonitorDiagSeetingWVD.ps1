# Variables #

# Set the post pool name and resource group
$hostpoolName = ''
$hostpoolResourcegroupName = ''

# WVD workspace resource group if different from Host Pool RG
# leave Null or blank if the same as the host pool
$wvdWorkspaceResourcegroup = ''

# Log Analytics Values
# Set the Lon Analytics Resource Group and Workspace Name
$loganalyticsWorkspaceResourcegroup = ''
$loganalyticsWorkspaceName = ''


#Functions
function Add-LaDiag {
    param(
        [string]$laWorkspaceID,
        [array]$resourceList
    )
    foreach ($resource in $resourceList) {
        $name = ($resource.Split('/'))[-1] + "-Diagnostics"
        try {

            Set-AzDiagnosticSetting -ErrorAction Stop -Name $name -ResourceId $resource -Enabled $true -WorkspaceId $laWorkspaceID
        }
        catch{
            $ErrorMessage = $_.Exception.message
            Write-Error ("Adding diag settings for $name had the following error: " + $ErrorMessage)
        }
    }
}


# Get the Log Analytics Workspace Resource ID
$laWorkspaceID = (Get-AzOperationalInsightsWorkspace -ResourceGroupName $loganalyticsWorkspaceResourcegroup -Name $loganalyticsWorkspaceName).resourceId

# Build the list of resource ID's
$resourceIds = @()

# Get the host pool resource ID
$hostpool = Get-AzWvdHostPool -name $hostpoolName -ResourceGroupName $hostpoolResourcegroupName
$resourceIds += $hostpool.Id

# Add the App Groups Resource ID
foreach ($appGroupId in $hostpool.ApplicationGroupReference) {
    $resourceIds += $appGroupId
}

# Get the WVD Workspace Resource ID
if (($wvdWorkspaceResourcegroup -eq '') -or ($wvdWorkspaceResourcegroup -eq $nul)) {
    $wvdWorkspaceResourcegroup = $hostpoolResourcegroupName
}
$wvdWorkspaceId = (Get-AzWvdWorkspace -ResourceGroupName $wvdWorkspaceResourcegroup).Id
$resourceIds += $wvdWorkspaceId

# Execute the function

Add-LADiag -laWorkspaceID $laWorkspaceID -resourceList $resourceIds