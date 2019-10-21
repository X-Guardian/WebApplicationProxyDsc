<#
    .SYNOPSIS
        DSC module for the WebApplicationProxyApplication resource

    .DESCRIPTION

        The WebApplicationProxyApplication DSC resource manages the publishing of a web application through Web
        Application Proxy.

        Use this resource to specify a name for the web application, and to provide an external address and the address
        of the backend server. External clients connect to the external address to access the web application hosted by
        the backend server. The resource checks the external address to verify that no other published web application
        uses it on any of the proxies in the current Active Directory Federation Services (AD FS) installation.

        You can specify the relying party for use with AD FS, the service principal name (SPN) of the backend server, a
        certificate thumbprint for the external address, the method of preauthentication, and whether the proxy
        provides the URL of the federation server to users of Open Authorization (OAuth). You can also specify whether
        the application proxy validates the certificate from the backend server and verifies whether the certificate
        that authenticates the federation server authenticates future requests.

        The proxy can translate URLs in headers. You can disable translation in either request or response headers, or
        both.

        You can also specify a time-out value for inactive connections.

    .PARAMETER Name
        Key - String
        Specifies a friendly name for the published web application.

    .PARAMETER ExternalUrl
        Required - String
        Specifies the external address, as a URL, for the web application. Include the trailing slash (/).

    .PARAMETER BackendServerUrl
        Required - String
        Specifies the backend address of the web application. Specify by protocol and host name or IP address. Include
        the trailing slash (/). You can also include a port number and path.

    .PARAMETER ADFSRelyingPartyName
        Write - String
        Specifies the name of the relying party configured on the AD FS federation server.

    .PARAMETER ADFSUserCertificateStore
        Write - String
        Specifies the certificate store for a AD FS user.

    .PARAMETER BackendServerAuthenticationSPN
        Write - String
        Specifies the service principal name (SPN) of the backend server. Use this parameter if the application that
        the backend server hosts uses Integrated Windows authentication.

    .PARAMETER BackendServerCertificateValidation
        Write - String
        Allowed values: None, ValidateCertificate
        Specifies whether Web Application Proxy validates the certificate that the backend server presents with the WAP
        configuration per application.

    .PARAMETER ClientCertificateAuthenticationBindingMode
        Write - String
        Allowed values: None, ValidateCertificate
        If this parameter is set to ValidateCertificate then the browser sends a certificate with each request and
        validates that the device certificate thumbprint from the certificate is included in the token or the cookie.

    .PARAMETER ClientCertificatePreauthenticationThumbprint
        Write - String
        Specifies the certificate thumbprint, as a string, of the certificate that a client supplies for the
        preauthentication feature. The thumbprint is 40 hexadecimal characters. This parameter is only relevant when
        you specify the value of ClientCertificate for the ExternalPreauthentication parameter.

    .PARAMETER DisableHttpOnlyCookieProtection
        Write - Boolean
        Indicates that this resource disables the use of the HttpOnly flag when Web Application Proxy sets the access
        cookie. The access cookie provides single sign-on access to an application.

    .PARAMETER DisableTranslateUrlInRequestHeaders
        Write - Boolean
        Indicates that Web Application Proxy does not translate HTTP host headers from public host headers to internal
        host headers when it forwards the request to the published application. Specify this parameter if the
        application uses path-based information.

    .PARAMETER DisableTranslateUrlInResponseHeaders
        Write - Boolean
        Indicates that Web Application Proxy does not translate internal host names to public host names in
        Content-Location, Location, and Set-Cookie response headers in redirect responses.

    .PARAMETER EnableHTTPRedirect
        Write - Boolean
        Indicates that this resource enables HTTP redirect for Web Application Proxy.

    .PARAMETER EnableSignOut
        Write - Boolean
        Indicates whether to enable sign out for Web Application Proxy.

    .PARAMETER ExternalCertificateThumbprint
        Write - String
        Specifies the certificate thumbprint of the certificate to use for the address specified by the ExternalUrl
        parameter. The certificate must exist in the Local Computer or Local Personal certificate store. You can use a
        simple certificate, a subject alternative name (SAN) certificate, or a wildcard certificate.

    .PARAMETER ExternalPreauthentication
        Write - String
        Allowed values: ADFS, ClientCertificate, PassThrough, ADFSforRichClients, ADFSforOAuth, ADFSforBrowsersAndOffice
        Specifies the preauthentication method that Web Application Proxy uses.

    .PARAMETER InactiveTransactionsTimeoutSec
        Write - UInt32
        Specifies the length of time, in seconds, until Web Application Proxy closes incomplete HTTP transactions.

    .PARAMETER PersistentAccessCookieExpirationTimeSec
        Write - UInt32
        Specifies the expiration time, in seconds, for persistent access cookies.

    .PARAMETER UseOAuthAuthentication
        Write - Boolean
        Indicates that Web Application Proxy provides the URL of the federation server that performs Open Authorization
        (OAuth) when users connect to the application by using a Windows Store app.

    .PARAMETER Id
        Read - String
        Shows the GUID of the Web application

    .PARAMETER Ensure
        Write - String
        Allowed values: Present, Absent
        Specifies whether the resource should be present or absent. Default value is 'Present'.
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
        - Get-WebApplicationProxyApplication - https://docs.microsoft.com/en-us/powershell/module/webapplicationproxy/get-webapplicationproxyapplication
    #>

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ExternalUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $BackendServerUrl
    )

    # Check of the Resource PowerShell module is installed
    Assert-Module -ModuleName $script:PSModuleName

    Write-Verbose ($script:localizedData.GettingResourceMessage -f $Name)

    try
    {
        $targetResource = Get-WebApplicationProxyApplication -Name $Name
    }
    catch
    {
        $errorMessage = $script:localizedData.GettingResourceError -f $Name
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }


    if ($targetResource)
    {
        # Resource exists
        $returnValue = @{
            Name                                         = $targetResource.Name
            ExternalUrl                                  = $targetResource.ExternalUrl
            BackendServerUrl                             = $targetResource.BackendServerUrl
            ADFSRelyingPartyName                         = $targetResource.ADFSRelyingPartyName
            ADFSUserCertificateStore                     = $targetResource.ADFSUserCertificateStore
            BackendServerAuthenticationSPN               = $targetResource.BackendServerAuthenticationSPN
            BackendServerCertificateValidation           = $targetResource.BackendServerCertificateValidation
            ClientCertificateAuthenticationBindingMode   = $targetResource.ClientCertificateAuthenticationBindingMode
            ClientCertificatePreauthenticationThumbprint = $targetResource.ClientCertificatePreauthenticationThumbprint
            DisableHttpOnlyCookieProtection              = $targetResource.DisableHttpOnlyCookieProtection
            DisableTranslateUrlInRequestHeaders          = $targetResource.DisableTranslateUrlInRequestHeaders
            DisableTranslateUrlInResponseHeaders         = $targetResource.DisableTranslateUrlInResponseHeaders
            EnableHTTPRedirect                           = $targetResource.EnableHTTPRedirect
            EnableSignOut                                = $targetResource.EnableSignOut
            ExternalCertificateThumbprint                = $targetResource.ExternalCertificateThumbprint
            ExternalPreauthentication                    = $targetResource.ExternalPreauthentication
            InactiveTransactionsTimeoutSec               = $targetResource.InactiveTransactionsTimeoutSec
            PersistentAccessCookieExpirationTimeSec      = $targetResource.PersistentAccessCookieExpirationTimeSec
            UseOAuthAuthentication                       = $targetResource.UseOAuthAuthentication
            Id                                           = $targetResource.Id
            Ensure                                       = 'Present'
        }
    }
    else
    {
        # Resource does not exist
        $returnValue = @{
            Name                                         = $Name
            ExternalUrl                                  = $ExternalUrl
            BackendServerUrl                             = $BackendServerUrl
            ADFSRelyingPartyName                         = $null
            ADFSUserCertificateStore                     = $null
            BackendServerAuthenticationSPN               = $null
            BackendServerCertificateValidation           = 'None'
            ClientCertificateAuthenticationBindingMode   = 'none'
            ClientCertificatePreauthenticationThumbprint = $null
            DisableHttpOnlyCookieProtection              = $false
            DisableTranslateUrlInRequestHeaders          = $false
            DisableTranslateUrlInResponseHeaders         = $false
            EnableHTTPRedirect                           = $false
            EnableSignOut                                = $false
            ExternalCertificateThumbprint                = $null
            ExternalPreauthentication                    = 'PassThrough'
            InactiveTransactionsTimeoutSec               = $null
            PersistentAccessCookieExpirationTimeSec      = $null
            UseOAuthAuthentication                       = $false
            Id                                           = $null
            Ensure                                       = 'Absent'
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
        - Add-WebApplicationProxyApplication - https://docs.microsoft.com/en-us/powershell/module/webapplicationproxy/add-webapplicationproxyapplication
        - Set-WebApplicationProxyApplication - https://docs.microsoft.com/en-us/powershell/module/webapplicationproxy/set-webapplicationproxyapplication
        - Remove-WebApplicationProxyApplication - https://docs.microsoft.com/en-us/powershell/module/webapplicationproxy/remove-webapplicationproxyapplication
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ExternalUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $BackendServerUrl,

        [Parameter()]
        [System.String]
        $ADFSRelyingPartyName,

        [Parameter()]
        [System.String]
        $ADFSUserCertificateStore,

        [Parameter()]
        [System.String]
        $BackendServerAuthenticationSPN,

        [Parameter()]
        [ValidateSet('None', 'ValidateCertificate')]
        [System.String]
        $BackendServerCertificateValidation,

        [Parameter()]
        [ValidateSet('None', 'ValidateCertificate')]
        [System.String]
        $ClientCertificateAuthenticationBindingMode,

        [Parameter()]
        [System.String]
        $ClientCertificatePreauthenticationThumbprint,

        [Parameter()]
        [System.Boolean]
        $DisableHttpOnlyCookieProtection,

        [Parameter()]
        [System.Boolean]
        $DisableTranslateUrlInRequestHeaders,

        [Parameter()]
        [System.Boolean]
        $DisableTranslateUrlInResponseHeaders,

        [Parameter()]
        [System.Boolean]
        $EnableHTTPRedirect,

        [Parameter()]
        [System.Boolean]
        $EnableSignOut,

        [Parameter()]
        [System.String]
        $ExternalCertificateThumbprint,

        [Parameter()]
        [ValidateSet('ADFS', 'ClientCertificate', 'PassThrough', 'ADFSforRichClients', 'ADFSforOAuth', 'ADFSforBrowsersAndOffice')]
        [System.String]
        $ExternalPreauthentication,

        [Parameter()]
        [System.UInt32]
        $InactiveTransactionsTimeoutSec,

        [Parameter()]
        [System.UInt32]
        $PersistentAccessCookieExpirationTimeSec,

        [Parameter()]
        [System.Boolean]
        $UseOAuthAuthentication,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    # Remove any parameters not used in Splats
    $parameters = $PSBoundParameters
    $parameters.Remove('Ensure')
    $parameters.Remove('Verbose')

    $getTargetResourceParms = @{
        Name             = $Name
        ExternalUrl      = $ExternalUrl
        BackendServerUrl = $BackendServerUrl
    }
    $targetResource = Get-TargetResource @getTargetResourceParms

    if ($Ensure -eq 'Present')
    {
        # Resource should exist
        if ($TargetResource.Ensure -eq 'Present')
        {
            # Resource exists
            $createNewResource = $false
            $propertiesNotInDesiredState = (
                Compare-ResourcePropertyState -CurrentValues $targetResource -DesiredValues $parameters |
                    Where-Object -Property InDesiredState -eq $false)

            if ($propertiesNotInDesiredState)
            {
                if ($propertiesNotInDesiredState.ParameterName -contains 'ADFSRelyingPartyName' -or
                    $propertiesNotInDesiredState.ParameterName -contains 'ExternalPreauthentication')
                {
                    # ADFSRelyingPartyName or ExternalPreauthentication has changed, so the resource needs recreating
                    Write-Verbose -Message ($script:localizedData.RecreatingResourceMessage -f $Name)
                    Write-Verbose -Message ($script:localizedData.RemovingResourceMessage -f $Name)
                    try
                    {
                        Remove-WebApplicationProxyApplication -Name $Name
                    }
                    catch
                    {
                        $errorMessage = $script:localizedData.RemovingResourceError -f $Name
                        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
                    }

                    $createNewResource = $true
                }
                else
                {
                    $SetParameters = New-Object -TypeName System.Collections.Hashtable
                    foreach ($property in $propertiesNotInDesiredState)
                    {
                        Write-Verbose -Message ($script:localizedData.SettingResourceMessage -f
                            $Name, $property.ParameterName, ($property.Expected -join ', '))
                        $SetParameters.add($property.ParameterName, $property.Expected)
                    }

                    try
                    {
                        Set-WebApplicationProxyApplication -Id $targetResource.Id @SetParameters
                    }
                    catch
                    {
                        $errorMessage = $script:localizedData.SettingResourceError -f $Name
                        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
                    }
                }
            }
        }
        else
        {
            # Resource does not exist
            $createNewResource = $true
        }

        if ($createNewResource)
        {
            Write-Verbose -Message ($script:localizedData.AddingResourceMessage -f $Name)
            try
            {
                Add-WebApplicationProxyApplication @parameters
            }
            catch
            {
                $errorMessage = $script:localizedData.AddingResourceError -f $Name
                New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
            }
        }
    }
    else
    {
        # Resource should not exist
        if ($TargetResource.Ensure -eq 'Present')
        {
            # Resource exists
            Write-Verbose -Message ($script:localizedData.RemovingResourceMessage -f $Name)

            try
            {
                Remove-WebApplicationProxyApplication -Name $Name
            }
            catch
            {
                $errorMessage = $script:localizedData.RemovingResourceError -f $Name
                New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
            }
        }
        else
        {
            # Resource does not exist
            Write-Verbose -Message ($script:localizedData.ResourceInDesiredStateMessage -f $Name)
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
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ExternalUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $BackendServerUrl,

        [Parameter()]
        [System.String]
        $ADFSRelyingPartyName,

        [Parameter()]
        [System.String]
        $ADFSUserCertificateStore,

        [Parameter()]
        [System.String]
        $BackendServerAuthenticationSPN,

        [Parameter()]
        [ValidateSet('None', 'ValidateCertificate')]
        [System.String]
        $BackendServerCertificateValidation,

        [Parameter()]
        [ValidateSet('None', 'ValidateCertificate')]
        [System.String]
        $ClientCertificateAuthenticationBindingMode,

        [Parameter()]
        [System.String]
        $ClientCertificatePreauthenticationThumbprint,

        [Parameter()]
        [System.Boolean]
        $DisableHttpOnlyCookieProtection,

        [Parameter()]
        [System.Boolean]
        $DisableTranslateUrlInRequestHeaders,

        [Parameter()]
        [System.Boolean]
        $DisableTranslateUrlInResponseHeaders,

        [Parameter()]
        [System.Boolean]
        $EnableHTTPRedirect,

        [Parameter()]
        [System.Boolean]
        $EnableSignOut,

        [Parameter()]
        [System.String]
        $ExternalCertificateThumbprint,

        [Parameter()]
        [ValidateSet('ADFS', 'ClientCertificate', 'PassThrough', 'ADFSforRichClients', 'ADFSforOAuth', 'ADFSforBrowsersAndOffice')]
        [System.String]
        $ExternalPreauthentication,

        [Parameter()]
        [System.UInt32]
        $InactiveTransactionsTimeoutSec,

        [Parameter()]
        [System.UInt32]
        $PersistentAccessCookieExpirationTimeSec,

        [Parameter()]
        [System.Boolean]
        $UseOAuthAuthentication,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    $GetTargetResourceParms = @{
        Name             = $Name
        ExternalUrl      = $ExternalUrl
        BackendServerUrl = $BackendServerUrl
    }
    $targetResource = Get-TargetResource @GetTargetResourceParms

    if ($targetResource.Ensure -eq 'Present')
    {
        # Resource exists
        if ($Ensure -eq 'Present')
        {
            # Resource should exist
            $propertiesNotInDesiredState = (
                Compare-ResourcePropertyState -CurrentValues $targetResource -DesiredValues $PSBoundParameters |
                    Where-Object -Property InDesiredState -eq $false)
            if ($propertiesNotInDesiredState)
            {
                # Resource is not in desired state
                foreach ($property in $propertiesNotInDesiredState)
                {
                    Write-Verbose -Message ($script:localizedData.ResourcePropertyNotInDesiredStateMessage -f
                        $targetResource.Name, $property.ParameterName, $property.Expected, $property.Actual)
                }
                $inDesiredState = $false
            }
            else
            {
                # Resource is in desired state
                Write-Verbose -Message ($script:localizedData.ResourceInDesiredStateMessage -f
                    $targetResource.Name)
                $inDesiredState = $true
            }
        }
        else
        {
            # Resource should not exist
            Write-Verbose -Message ($script:localizedData.ResourceExistsButShouldNotMessage -f
                $targetResource.Name)
            $inDesiredState = $false
        }
    }
    else
    {
        # Resource does not exist
        if ($Ensure -eq 'Present')
        {
            # Resource should exist
            Write-Verbose -Message ($script:localizedData.ResourceDoesNotExistButShouldMessage -f
                $targetResource.Name)
            $inDesiredState = $false
        }
        else
        {
            # Resource should not exist
            Write-Verbose ($script:localizedData.ResourceDoesNotExistAndShouldNotMessage -f
                $targetResource.Name)
            $inDesiredState = $true
        }
    }

    $inDesiredState
}

Export-ModuleMember -Function *-TargetResource
