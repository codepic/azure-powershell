function Migrate-AzureResourceGroup {
<#
.SYNOPSIS
    Moves all resources from one resource group to another.

.DESCRIPTION
    Uses AzureRM.Resources module to move resources from one group to another.

.PARAMETER FromGroupName
    Name of the group where to move resources from

.PARAMETER ToGroupName
    Name of the group where to move resources to

.EXAMPLE
    Rename-AzureResourceGroup -FromGroupName 'MyOldGroup' -ToGroupName 'MyNewGroup'

#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $FromGroupName,
        [Parameter(Mandatory=$true)]
        [string] $ToGroupName
    )

    Process {

		# Try to find AzureRM module
        if (Get-Module -ListAvailable -Name AzureRM) {
            Import-Module AzureRM 
        } else {
			# Install if not found
            Install-Module AzureRM
        }

		# Try to find AzureRM.Resouces module
        if (Get-Module -ListAvailable -Name AzureRM.Resources) {
            Import-Module AzureRM.Resources
        } else {
			# Install if not found
            Install-Module AzureRM.Resources
        }

		# Check if we're logged on
        try{
            Get-AzureRmContext | Out-Null
        } catch {
			# Request login if not yet authenticated
            Login-AzureRmAccount -ErrorAction Stop
        }

		# Do the actual work
        Find-AzureRmResource -Verbose | 
            Where-Object {
				# Filter by FromGroupName param
                $_.ResourceGroupName -eq $FromGroupName
            } |
            ForEach-Object {
				# Move found resources
                Move-AzureRmResource -DestinationResourceGroupName $ToGroupName -ResourceId $_.ResourceId
            }

        }

}

#Get-Help Migrate-AzureResourceGroup
Migrate-AzureResourceGroup -FromGroupName 'VS-codepic-Group' -ToGroupName 'codepic-alm-vso'

