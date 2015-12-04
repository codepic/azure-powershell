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

        if (Get-Module -ListAvailable -Name AzureRM) {
            Import-Module AzureRM
        } else {
            Install-Module AzureRM
        }

        if (Get-Module -ListAvailable -Name AzureRM.Resources) {
            Import-Module AzureRM.Resources
        } else {
            Install-Module AzureRM.Resources
        }

        try{
            Get-AzureRmContext | Out-Null
        } catch {
            Login-AzureRmAccount -ErrorAction Stop
        }


        Find-AzureRmResource -Verbose | 
            Where-Object {
                $_.ResourceGroupName -eq $FromGroupName
            } |
            ForEach-Object {
                Move-AzureRmResource -DestinationResourceGroupName $ToGroupName -ResourceId $_.ResourceId
            }

        }

}

#Get-Help Migrate-AzureResourceGroup
Migrate-AzureResourceGroup -FromGroupName 'VS-codepic-Group' -ToGroupName 'codepic-alm-vso'

