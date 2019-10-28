<#
    .SYNOPSIS
        DSC module for the WebApplicationProxyConfiguration resource

    .DESCRIPTION
        The WebApplicationProxyConfiguration DSC resource manages the configuration settings of a Web Application Proxy
        server. The settings include the Active Directory Federation Services (AD FS) URL, the token signing
        certificate, and the edge server URI.

    .PARAMETER FederationServiceName
        Key - String
        Specifies the name of a Federation Service. This is the Federation Service for which Web Application Proxy
        provides AD FS proxy functionality and stores the configuration of the Federation Service.

    .PARAMETER ADFSSignOutURL
        Write - String
        Specifies the sign out URL for Web Application Proxy.

    .PARAMETER ADFSTokenAcceptanceDurationSec
        Write - UInt32

    .PARAMETER ADFSTokenSigningCertificatePublicKey
        Write - String
        Specifies the thumbprint of the certificate that the federation server uses to sign the edge token. Specify
        this parameter only when the AD FS token signing certificate changes.

    .PARAMETER ADFSUrl
        Write - String
        Specifies the URL for the federation server that is used by the Web Application Proxy.

    .PARAMETER ADFSWebApplicationProxyRelyingPartyUri
        Write - String
        Specifies the URI for the Web Application Proxy server.

    .PARAMETER ConfigurationChangesPollingIntervalSec
        Write - UInt32
        Specifies the time interval, in seconds, that elapses before the Web Application Proxy servers query a
        federation server for configuration changes.

    .PARAMETER ConnectedServersName
        Write - String
        Specifies an array of Web Application Proxy servers that are connected to a federation server.

    .PARAMETER OAuthAuthenticationURL
        Write - String
        Specifies the URL of the federation server that performs Open Authorization (OAuth) authentication when end
        users connect to a published web application using a Windows Store app.

    .PARAMETER UserIdleTimeoutAction
        Write - String
        Allowed values: Signout, Reauthenticate

    .PARAMETER UserIdleTimeoutSec
        Write - UInt32
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

    # Check of the Resource PowerShell module is installed
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
    [HashTable]$parameters = $PSBoundParameters
    $parameters.Remove('FederationServiceName')
    $parameters.Remove('Verbose')

    $getTargetResourceParms = @{
        FederationServiceName = $FederationServiceName
    }
    $targetResource = Get-TargetResource @getTargetResourceParms

    $propertiesNotInDesiredState = (
        Compare-ResourcePropertyState -CurrentValues $targetResource -DesiredValues $PSBoundParameters |
            Where-Object -Property InDesiredState -eq $false)

    $setParameters = @{ }
    foreach ($property in $propertiesNotInDesiredState)
    {
        Write-Verbose -Message (
            $script:localizedData.SettingResourceMessage -f
            $FederationServiceName, $property.ParameterName, ($property.Expected -join ', '))
        $setParameters.Add($property.ParameterName, $property.Expected)
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

    [HashTable]$parameters = $PSBoundParameters
    $parameters.Remove('FederationServiceName')

    $GetTargetResourceParms = @{
        FederationServiceName = $FederationServiceName
    }
    $targetResource = Get-TargetResource @GetTargetResourceParms

    $propertiesNotInDesiredState = (
        Compare-ResourcePropertyState -CurrentValues $targetResource -DesiredValues $parameters |
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
