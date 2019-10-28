<#
    .SYNOPSIS
        DSC module for the Web Application Proxy SSL Certificate resource

    .DESCRIPTION
        The WebApplicationProxySslCertificate Dsc resource manages an Active Directory Federation
        Services (AD FS) Secure Sockets Layer (SSL) certificate for the federation server proxy
        component of the Web Application Proxy.

    .PARAMETER CertificateType
        Key - String
        Allowed values: Https-Binding
        Specifies the certificate type, must be 'Https-Binding'.

    .PARAMETER Thumbprint
        Required - String
        Specifies the thumbprint of the certificate to use.
#>

Set-StrictMode -Version 2.0

$script:dscModuleName = 'WebApplicationProxyDsc'
$script:psModuleName = 'WebApplicationProxy'
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
        - Get-WebApplicationProxySslCertificate - https://docs.microsoft.com/en-us/powershell/module/WebApplicationProxy/get-WebApplicationProxysslcertificate
    #>

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Https-Binding")]
        [System.String]
        $CertificateType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Thumbprint
    )

    # Check of the Resource PowerShell module is installed
    Assert-Module -ModuleName $script:psModuleName

    Write-Verbose -Message ($script:localizedData.GettingResourceMessage -f $CertificateType)

    try
    {
        $targetResource = Get-WebApplicationProxySslCertificate | Select-Object -First 1
    }
    catch
    {
        $errorMessage = $script:localizedData.GettingResourceError -f $CertificateType
        New-InvalidOperationException -Message $errorMessage -Error $_
    }
    $returnValue = @{
        CertificateType = $CertificateType
        Thumbprint      = $targetResource.CertificateHash
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
        - Set-WebApplicationProxySslCertificate - https://docs.microsoft.com/en-us/powershell/module/WebApplicationProxy/set-WebApplicationProxysslcertificate
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Https-Binding")]
        [System.String]
        $CertificateType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Thumbprint
    )

    [HashTable]$parameters = $PSBoundParameters
    $parameters.Remove('CertificateType')

    $getTargetResourceParms = @{
        CertificateType = $CertificateType
        Thumbprint      = $Thumbprint
    }
    $targetResource = Get-TargetResource @getTargetResourceParms

    $propertiesNotInDesiredState = (
        Compare-ResourcePropertyState -CurrentValues $targetResource -DesiredValues $parameters |
            Where-Object -Property InDesiredState -eq $false)

    $setParameters = @{ }
    foreach ($property in $propertiesNotInDesiredState)
    {
        Write-Verbose -Message (
            $script:localizedData.SettingResourceMessage -f
            $CertificateType, $property.ParameterName, ($property.Expected -join ', '))
        $setParameters.add($property.ParameterName, $property.Expected)
    }

    try
    {
        Set-WebApplicationProxySslCertificate @setParameters
    }
    catch
    {
        $errorMessage = $script:localizedData.SettingResourceError -f $CertificateType
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
        [ValidateSet("Https-Binding")]
        [System.String]
        $CertificateType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Thumbprint
    )

    $getTargetResourceParms = @{
        CertificateType = $CertificateType
        Thumbprint      = $Thumbprint
    }
    $targetResource = Get-TargetResource @getTargetResourceParms

    $propertiesNotInDesiredState = (
        Compare-ResourcePropertyState -CurrentValues $targetResource -DesiredValues $PSBoundParameters |
            Where-Object -Property InDesiredState -eq $false)

    if ($propertiesNotInDesiredState)
    {
        # Resource is not in desired state
        foreach ($property in $propertiesNotInDesiredState)
        {
            Write-Verbose -Message (
                $script:localizedData.ResourcePropertyNotInDesiredStateMessage -f
                $targetResource.CertificateType, $property.ParameterName,
                $property.Expected, $property.Actual)

        }
        $inDesiredState = $false
    }
    else
    {
        # Resource is in desired state
        Write-Verbose -Message (
            $script:localizedData.ResourceInDesiredStateMessage -f $CertificateType)
        $inDesiredState = $true
    }

    $inDesiredState
}

Export-ModuleMember -Function *-TargetResource
