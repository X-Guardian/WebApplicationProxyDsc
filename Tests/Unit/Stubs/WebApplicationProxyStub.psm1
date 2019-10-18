# Name: WebApplicationProxy
# Version: 1.0.0.0
# CreatedOn: 2019-10-15 13:47:00Z

function Add-WebApplicationProxyApplication {
    <#
    .SYNOPSIS
        Add-WebApplicationProxyApplication [-Name] <string> -ExternalUrl <string> -BackendServerUrl <string> [-ExternalPreauthentication <string>] [-ClientCertificateAuthenticationBindingMode <string>] [-BackendServerCertificateValidation <string>] [-ExternalCertificateThumbprint <string>] [-EnableSignOut] [-InactiveTransactionsTimeoutSec <uint32>] [-ClientCertificatePreauthenticationThumbprint <string>] [-EnableHTTPRedirect] [-ADFSUserCertificateStore <string>] [-DisableHttpOnlyCookieProtection] [-PersistentAccessCookieExpirationTimeSec <uint32>] [-DisableTranslateUrlInRequestHeaders] [-DisableTranslateUrlInResponseHeaders] [-BackendServerAuthenticationSPN <string>] [-ADFSRelyingPartyName <string>] [-UseOAuthAuthentication] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]
    #>

    [CmdletBinding(PositionalBinding=$false)]
    param (
        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [Alias('FriendlyName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 256)]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [Alias('PreAuthN')]
        [ValidateSet('PassThrough','ADFS','ClientCertificate','ADFSforRichClients','ADFSforOAuth','ADFSforBrowsersAndOffice')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ExternalPreauthentication},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('None','ValidateCertificate')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ClientCertificateAuthenticationBindingMode},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('None','ValidateCertificate')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${BackendServerCertificateValidation},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ExternalUrl},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [Alias('ExternalCert')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ExternalCertificateThumbprint},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${EnableSignOut},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${InactiveTransactionsTimeoutSec},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [string]
        ${ClientCertificatePreauthenticationThumbprint},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${EnableHTTPRedirect},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [string]
        ${ADFSUserCertificateStore},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${DisableHttpOnlyCookieProtection},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${PersistentAccessCookieExpirationTimeSec},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('BackendUrl')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${BackendServerUrl},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${DisableTranslateUrlInRequestHeaders},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${DisableTranslateUrlInResponseHeaders},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [Alias('SPN')]
        [ValidateNotNull()]
        [string]
        ${BackendServerAuthenticationSPN},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [Alias('RPName')]
        [ValidateNotNull()]
        [string]
        ${ADFSRelyingPartyName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${UseOAuthAuthentication},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Get-WebApplicationProxyApplication {
    <#
    .SYNOPSIS
        Get-WebApplicationProxyApplication -ID <guid> [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]

Get-WebApplicationProxyApplication [[-Name] <string>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#PublishedWebApp')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#PublishedWebApp')]
    param (
        [Parameter(ParameterSetName='ID', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [guid]
        ${ID},

        [Parameter(ParameterSetName='Name', Position=0, ValueFromPipelineByPropertyName=$true)]
        [Alias('FriendlyName')]
        [AllowNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='ID')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='ID')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='ID')]
        [switch]
        ${AsJob}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Get-WebApplicationProxyAvailableADFSRelyingParty {
    <#
    .SYNOPSIS
        Get-WebApplicationProxyAvailableADFSRelyingParty [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#RelyingPartyMetadata')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Get-WebApplicationProxyConfiguration {
    <#
    .SYNOPSIS
        Get-WebApplicationProxyConfiguration [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#AppProxyGlobalConfiguration')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Remove-WebApplicationProxyApplication {
    <#
    .SYNOPSIS
        Remove-WebApplicationProxyApplication [-ID] <guid[]> [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]

Remove-WebApplicationProxyApplication [-Name] <string> [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='ID', PositionalBinding=$false)]
    param (
        [Parameter(ParameterSetName='ID', Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('ApplicationID')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [guid[]]
        ${ID},

        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='ID')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='ID')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='ID')]
        [switch]
        ${AsJob}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Set-WebApplicationProxyApplication {
    <#
    .SYNOPSIS
        Set-WebApplicationProxyApplication [-ID] <guid> [-ClientCertificateAuthenticationBindingMode <string>] [-BackendServerCertificateValidation <string>] [-ExternalUrl <string>] [-ExternalCertificateThumbprint <string>] [-BackendServerUrl <string>] [-DisableTranslateUrlInRequestHeaders] [-EnableHTTPRedirect] [-ADFSUserCertificateStore <string>] [-DisableHttpOnlyCookieProtection] [-PersistentAccessCookieExpirationTimeSec <uint32>] [-EnableSignOut] [-BackendServerAuthenticationMode <string>] [-DisableTranslateUrlInResponseHeaders] [-BackendServerAuthenticationSPN <string>] [-Name <string>] [-UseOAuthAuthentication] [-InactiveTransactionsTimeoutSec <uint32>] [-ClientCertificatePreauthenticationThumbprint <string>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]
    #>

    [CmdletBinding(PositionalBinding=$false)]
    param (
        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('None','ValidateCertificate')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ClientCertificateAuthenticationBindingMode},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('None','ValidateCertificate')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${BackendServerCertificateValidation},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ExternalUrl},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [Alias('ExternalCert')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ExternalCertificateThumbprint},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [Alias('BackendUrl')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${BackendServerUrl},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${DisableTranslateUrlInRequestHeaders},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${EnableHTTPRedirect},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [string]
        ${ADFSUserCertificateStore},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${DisableHttpOnlyCookieProtection},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${PersistentAccessCookieExpirationTimeSec},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${EnableSignOut},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [string]
        ${BackendServerAuthenticationMode},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${DisableTranslateUrlInResponseHeaders},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [Alias('SPN')]
        [ValidateNotNull()]
        [string]
        ${BackendServerAuthenticationSPN},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [Alias('FriendlyName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 256)]
        [string]
        ${Name},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${UseOAuthAuthentication},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${InactiveTransactionsTimeoutSec},

        [Parameter(ParameterSetName='ID', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [string]
        ${ClientCertificatePreauthenticationThumbprint},

        [Parameter(ParameterSetName='ID', Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [Alias('ApplicationID')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [guid]
        ${ID},

        [Parameter(ParameterSetName='ID')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='ID')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='ID')]
        [switch]
        ${AsJob}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Set-WebApplicationProxyConfiguration {
    <#
    .SYNOPSIS
        Set-WebApplicationProxyConfiguration [-ADFSUrl <uri>] [-ADFSTokenSigningCertificatePublicKey <string>] [-ADFSWebApplicationProxyRelyingPartyUri <uri>] [-RegenerateAccessCookiesEncryptionKey] [-ConnectedServersName <string[]>] [-OAuthAuthenticationURL <uri>] [-ConfigurationChangesPollingIntervalSec <uint32>] [-UpgradeConfigurationVersion] [-ADFSTokenAcceptanceDurationSec <uint32>] [-ADFSSignOutURL <uri>] [-UserIdleTimeoutSec <uint32>] [-UserIdleTimeoutAction <string>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]
    #>

    [CmdletBinding(PositionalBinding=$false)]
    param (
        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [uri]
        ${ADFSUrl},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateLength(1, 5000)]
        [string]
        ${ADFSTokenSigningCertificatePublicKey},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [uri]
        ${ADFSWebApplicationProxyRelyingPartyUri},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${RegenerateAccessCookiesEncryptionKey},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [string[]]
        ${ConnectedServersName},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [uri]
        ${OAuthAuthenticationURL},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateRange(1, 3600)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ConfigurationChangesPollingIntervalSec},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${UpgradeConfigurationVersion},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateRange(0, 3600)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ADFSTokenAcceptanceDurationSec},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [uri]
        ${ADFSSignOutURL},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${UserIdleTimeoutSec},

        [Parameter(ParameterSetName='Set1')]
        [ValidateSet('Signout','Reauthenticate')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${UserIdleTimeoutAction},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set1')]
        [switch]
        ${AsJob}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Get-WebApplicationProxyHealth {
    <#
    .SYNOPSIS
        Get-WebApplicationProxyHealth [<CommonParameters>]
    #>

    [CmdletBinding()]
    param ( )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Get-WebApplicationProxySslCertificate {
    <#
    .SYNOPSIS
        Get-WebApplicationProxySslCertificate [<CommonParameters>]
    #>

    [CmdletBinding()]
    param ( )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Install-WebApplicationProxy {
    <#
    .SYNOPSIS
        Install-WebApplicationProxy -FederationServiceTrustCredential <pscredential> -CertificateThumbprint <string> -FederationServiceName <string> [-HttpsPort <int>] [-TlsClientPort <int>] [-ForwardProxy <string>] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='Proxy')]
    param (
        [Parameter(Mandatory=$true)]
        [pscredential]
        ${FederationServiceTrustCredential},

        [Parameter(Mandatory=$true)]
        [ValidateLength(1, 8192)]
        [string]
        ${CertificateThumbprint},

        [Parameter(Mandatory=$true)]
        [ValidateLength(1, 255)]
        [string]
        ${FederationServiceName},

        [ValidateRange(0, 65535)]
        [int]
        ${HttpsPort},

        [ValidateRange(0, 65535)]
        [int]
        ${TlsClientPort},

        [string]
        ${ForwardProxy}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Set-WebApplicationProxySslCertificate {
    <#
    .SYNOPSIS
        Set-WebApplicationProxySslCertificate -Thumbprint <string> [-WhatIf] [-Confirm] [<CommonParameters>]
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [string]
        ${Thumbprint}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Update-WebApplicationProxyDeviceRegistration {
    <#
    .SYNOPSIS
        Update-WebApplicationProxyDeviceRegistration [-NetworkCredential] <pscredential> [<CommonParameters>]
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [pscredential]
        ${NetworkCredential}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

