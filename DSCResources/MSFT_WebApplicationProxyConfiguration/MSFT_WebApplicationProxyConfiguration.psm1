<#
    .SYNOPSIS
        DSC module for the Web Application Proxy Configuration resource

    .DESCRIPTION
#>

Set-StrictMode -Version 2.0

$script:dscModuleName = 'WebApplicationProxyDsc'
$script:PSModuleName = 'WebApplicationProxy'
$script:dscResourceName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)

$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath "$($script:DSCModuleName).Common"
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath "$($script:dscModuleName).Common.psm1")

$script:localizedData = Get-LocalizedData -ResourceName $script:dscResourceName

function Get-TargetResource
{
    <#
    .SYNOPSIS
        Get-TargetResource

    .NOTES
        Used Resource PowerShell Cmdlets:
        - Get-WebApplicationProxyConfiguration
    #>

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $FederationServiceName
    )

    # Check of the ADFS PowerShell module is installed
    Assert-Module -ModuleName $script:PSModuleName

    Write-Verbose -Message ($script:localizedData.GettingResourceMessage -f $FederationServiceName)

    try
    {
        $targetResource = Get-WebApplicationProxyConfiguration
    }
    catch
    {
        $errorMessage = $script:localizedData.GettingResourceError -f $FederationServiceName
        New-InvalidOperationException -Message $errorMessage -Error $_
    }

    $returnValue = @{
        FederationServiceName                  = $FederationServiceName
        ADFSSignOutURL                         = $targetResource.ADFSSignOutURL
        ADFSTokenAcceptanceDurationSec         = $targetResource.ADFSTokenAcceptanceDurationSec
        ADFSTokenSigningCertificatePublicKey   = $targetResource.ADFSTokenSigningCertificatePublicKey
        ADFSUrl                                = $targetResource.ADFSUrl
        ADFSWebApplicationProxyRelyingPartyUri = $targetResource.ADFSWebApplicationProxyRelyingPartyUri
        ConfigurationChangesPollingIntervalSec = $targetResource.ConfigurationChangesPollingIntervalSec
        ConnectedServersName                   = $targetResource.ConnectedServersName
        OAuthAuthenticationURL                 = $targetResource.OAuthAuthenticationURL
        UserIdleTimeoutAction                  = $targetResource.UserIdleTimeoutAction
        UserIdleTimeoutSec                     = $targetResource.UserIdleTimeoutSec
    }

    $returnValue
}


function Set-TargetResource
{
    <#
    .SYNOPSIS
        Set-TargetResource

    .NOTES
        Used Resource PowerShell Cmdlets:
        - Set-WebApplicationProxyConfiguration
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $FederationServiceName,

        [Parameter()]
        [System.String]
        $ADFSSignOutURL,

        [Parameter()]
        [System.UInt32]
        $ADFSTokenAcceptanceDurationSec,

        [Parameter()]
        [System.String]
        $ADFSTokenSigningCertificatePublicKey,

        [Parameter()]
        [System.String]
        $ADFSUrl,

        [Parameter()]
        [System.String]
        $ADFSWebApplicationProxyRelyingPartyUri,

        [Parameter()]
        [System.UInt32]
        $ConfigurationChangesPollingIntervalSec,

        [Parameter()]
        [System.String[]]
        $ConnectedServersName,

        [Parameter()]
        [System.String]
        $OAuthAuthenticationURL,

        [Parameter()]
        [ValidateSet('Signout', 'Reauthenticate')]
        [System.String]
        $UserIdleTimeoutAction,

        [Parameter()]
        [System.UInt32]
        $UserIdleTimeoutSec
    )

    # Remove any parameters not used in Splats
    [HashTable]$Parameters = $PSBoundParameters
    $Parameters.Remove('FederationServiceName')
    $Parameters.Remove('Verbose')

    $GetTargetResourceParms = @{
        FederationServiceName = $FederationServiceName
    }
    $targetResource = Get-TargetResource @GetTargetResourceParms

    $propertiesNotInDesiredState = (
        Compare-ResourcePropertyState -CurrentValues $targetResource -DesiredValues $PSBoundParameters |
            Where-Object -Property InDesiredState -eq $false)

    $SetParameters = New-Object -TypeName System.Collections.Hashtable
    foreach ($property in $propertiesNotInDesiredState)
    {
        Write-Verbose -Message (
            $script:localizedData.SettingResourceMessage -f
            $FederationServiceName, $property.ParameterName, ($property.Expected -join ', '))
        $SetParameters.add($property.ParameterName, $property.Expected)
    }

    try
    {
        Set-WebApplicationProxyConfiguration @SetParameters
    }
    catch
    {
        $errorMessage = $script:localizedData.SettingResourceError -f $FederationServiceName
        New-InvalidOperationException -Message $errorMessage -Error $_
    }
}


function Test-TargetResource
{
    <#
    .SYNOPSIS
        Test-TargetResource
    #>

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $FederationServiceName,

        [Parameter()]
        [System.String]
        $ADFSSignOutURL,

        [Parameter()]
        [System.UInt32]
        $ADFSTokenAcceptanceDurationSec,

        [Parameter()]
        [System.String]
        $ADFSTokenSigningCertificatePublicKey,

        [Parameter()]
        [System.String]
        $ADFSUrl,

        [Parameter()]
        [System.String]
        $ADFSWebApplicationProxyRelyingPartyUri,

        [Parameter()]
        [System.UInt32]
        $ConfigurationChangesPollingIntervalSec,

        [Parameter()]
        [System.String[]]
        $ConnectedServersName,

        [Parameter()]
        [System.String]
        $OAuthAuthenticationURL,

        [Parameter()]
        [ValidateSet('Signout', 'Reauthenticate')]
        [System.String]
        $UserIdleTimeoutAction,

        [Parameter()]
        [System.UInt32]
        $UserIdleTimeoutSec
    )

    [HashTable]$Parameters = $PSBoundParameters
    $Parameters.Remove('FederationServiceName')

    $GetTargetResourceParms = @{
        FederationServiceName = $FederationServiceName
    }
    $targetResource = Get-TargetResource @GetTargetResourceParms

    $propertiesNotInDesiredState = (
        Compare-ResourcePropertyState -CurrentValues $targetResource -DesiredValues $Parameters |
            Where-Object -Property InDesiredState -eq $false)

    if ($propertiesNotInDesiredState)
    {
        # Resource is not in desired state
        foreach ($property in $propertiesNotInDesiredState)
        {
            Write-Verbose -Message (
                $script:localizedData.ResourcePropertyNotInDesiredStateMessage -f
                $targetResource.FederationServiceName, $property.ParameterName, `
                    $property.Expected, $property.Actual)
        }
        $inDesiredState = $false
    }
    else
    {
        # Resource is in desired state
        Write-Verbose -Message ($script:localizedData.ResourceInDesiredStateMessage -f $FederationServiceName)
        $inDesiredState = $true
    }

    $inDesiredState
}

Export-ModuleMember -Function *-TargetResource
