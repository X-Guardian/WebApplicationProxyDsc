<#
    .SYNOPSIS
        DSC module for the Web Application Proxy resource

    .DESCRIPTION
        The WebApplicationProxy DSC resource manages the installation of the Web Application Proxy server role. To
        further manage the configuration of WebApplicationProxy, the WebApplicationProxyConfiguration DSC resource
        should be used.

        Note: removal of the Web Application Proxy role using this resource is not supported. Remove the
        Web-Application-Proxy role from the server instead.

    .PARAMETER FederationServiceName
        Key - String
        Specifies the name of a Federation Service. This is the Federation Service for which Web Application Proxy
        provides AD FS proxy functionality and stores the configuration of the Federation Service.

    .PARAMETER CertificateThumbprint
        Required - String
        Specifies the certificate thumbprint of the certificate that Web Application Proxy presents to users to
        identify the Web Application Proxy as a proxy for the Federation Service. The certificate must be in the
        Personal store for the local computer. You can use a simple certificate, a subject alternative name (SAN)
        certificate, or a wildcard certificate.

    .PARAMETER FederationServiceTrustCredential
        Required - String
        Specifies a PSCredential object that contains the credentials of the AD FS identity that is authorized to
        register new Federation server proxies. Specify an account that has permissions to manage the Federation
        Service.

    .PARAMETER ForwardProxy
        Write - String
        Specifies the DNS name and port number of an HTTP proxy that this federation server proxy uses to obtain access
        to the federation service. Specify the value for this parameter in the following format: FQDN:PortNumber.
        Note: This parameter applies only to Federation Services proxy. It does not apply for application publishing.

    .PARAMETER HttpsPort
        Write - Sint32
        Specifies the HTTPS port for the Web Application Proxy server. The default value is 443.

    .PARAMETER TlsClientPort
        Write - Sint32
        Specifies the port for the TLS client. Web Application Proxy uses this port for user certificate
        authentication. The default value is 49443.
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
        - Get-WebApplicationProxySslCertificate - https://docs.microsoft.com/en-us/powershell/module/webapplicationproxy/get-webapplicationproxysslcertificate
    #>

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $FederationServiceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbprint,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $FederationServiceTrustCredential
    )

    # Check of the WebApplicationProxy PowerShell module is installed
    Assert-Module -ModuleName $script:PSModuleName

    Write-Verbose -Message ($script:localizedData.GettingResourceMessage -f $FederationServiceName)

    # Check if the Web Application Proxy service has been configured
    if ((Get-WebApplicationProxyConfigurationStatus) -eq 'Configured')
    {
        try
        {
            $wapProxyService = Get-CimInstance -Namespace 'root/ADFS' `
                -ClassName 'ProxyService' -Verbose:$false
        }
        catch
        {
            $errorMessage = $script:localizedData.GettingWapProxyServiceError -f $FederationServiceName
            New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
        }

        try
        {
            $sslCertificateInfo = Get-WebApplicationProxySslCertificate | Select-Object -First 1
        }
        catch
        {
            $errorMessage = $script:localizedData.GettingWapSslCertificateError -f $FederationServiceName
            New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
        }

        if ($sslCertificateInfo)
        {
            $certificateThumbprint = $sslCertificateInfo.CertificateHash
        }
        else
        {
            $errorMessage = $script:localizedData.GettingWapSslCertificateError -f $FederationServiceName
            New-InvalidOperationException -Message $errorMessage
        }

        $returnValue = @{
            FederationServiceName            = $wapProxyService.HostName
            CertificateThumbprint            = $certificateThumbprint
            FederationServiceTrustCredential = $FederationServiceTrustcredential
            ForwardProxy                     = $wapProxyService.ForwardHttpProxyAddress
            HttpsPort                        = $wapProxyService.HostHttpsPort
            TlsClientPort                    = $wapProxyService.TlsClientPort
            Ensure                           = 'Present'
        }
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.ResourceNotFoundMessage -f $FederationServiceName)

        $returnValue = @{
            FederationServiceName            = $FederationServiceName
            CertificateThumbprint            = $CertificateThumbprint
            FederationServiceTrustCredential = $FederationServiceTrustcredential
            ForwardProxy                     = $null
            HttpsPort                        = $null
            TlsClientPort                    = $null
            Ensure                           = 'Absent'
        }
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
        - Install-WebApplicationProxy - https://docs.microsoft.com/en-us/powershell/module/webapplicationproxy/install-webapplicationproxy

        Install-WebApplicationProxy returns a [Microsoft.IdentityServer.Deployment.Core.Result] object with
        the following properties:

            Context - string
            Message - string
            Status  - Microsoft.IdentityServer.Deployment.Core.ResultStatus

        Examples:

            Message : The configuration completed successfully.
            Context : DeploymentSucceeded
            Status  : Success
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $FederationServiceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbprint,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $FederationServiceTrustCredential,

        [Parameter()]
        [System.String]
        $ForwardProxy,

        [Parameter()]
        [System.Int32]
        $HttpsPort,

        [Parameter()]
        [System.Int32]
        $TlsClientPort
    )

    # Remove any parameters not used in Splats
    [HashTable]$Parameters = $PSBoundParameters
    $Parameters.Remove('Verbose')

    $GetTargetResourceParms = @{
        FederationServiceName            = $FederationServiceName
        CertificateThumbprint            = $CertificateThumbprint
        FederationServiceTrustCredential = $FederationServiceTrustCredential
    }
    $targetResource = Get-TargetResource @GetTargetResourceParms

    # Web Application Proxy Service not installed
    if ($targetResource.Ensure -eq 'Absent')
    {
        try
        {
            Write-Verbose -Message ($script:localizedData.InstallingResourceMessage -f $FederationServiceName)
            $Result = Install-WebApplicationProxy @Parameters -ErrorAction SilentlyContinue
        }
        catch
        {
            $errorMessage = $script:localizedData.InstallationError -f $FederationServiceName
            New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
        }

        if ($Result.Status -eq 'Success')
        {
            Write-Verbose -Message ($script:localizedData.ResourceInstallSuccessMessage -f $FederationServiceName)
        }
        else
        {
            New-InvalidOperationException -Message $Result.Message
        }
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbprint,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $FederationServiceTrustCredential,

        [Parameter()]
        [System.String]
        $ForwardProxy,

        [Parameter()]
        [System.Int32]
        $HttpsPort,

        [Parameter()]
        [System.Int32]
        $TlsClientPort
    )

    Write-Verbose -Message ($script:localizedData.TestingResourceMessage -f $FederationServiceName)

    $GetTargetResourceParms = @{
        FederationServiceName            = $FederationServiceName
        CertificateThumbprint            = $CertificateThumbprint
        FederationServiceTrustCredential = $FederationServiceTrustCredential
    }
    $targetResource = Get-TargetResource @GetTargetResourceParms

    if ($targetResource.Ensure -eq 'Present')
    {
        # Resource is in desired state
        Write-Verbose -Message ($script:localizedData.ResourceInDesiredStateMessage -f
            $targetResource.FederationServiceName)
        $inDesiredState = $true
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.ResourceNotFoundMessage -f $FederationServiceName)
        $inDesiredState = $false
    }

    $inDesiredState
}

Export-ModuleMember -Function *-TargetResource
