<#PSScriptInfo
.VERSION 1.0.0
.GUID d84a7d6f-261b-4d7d-a41e-fd5dce2346a7
.AUTHOR Microsoft Corporation
.COMPANYNAME Microsoft Corporation
.COPYRIGHT (c) Microsoft Corporation. All rights reserved.
.TAGS DSCConfiguration
.LICENSEURI https://github.com/X-Guardian/WebApplicationProxyDsc/blob/master/LICENSE
.PROJECTURI https://github.com/X-Guardian/WebApplicationProxyDsc
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES First version.
.PRIVATEDATA 2016-Datacenter,2016-Datacenter-Server-Core
#>

#Requires -module 'PSDesiredStateConfiguration'
#Requires -module 'WebApplicationProxyDsc'

<#
    .DESCRIPTION
        This configuration will manage the installation of the Web Application Proxy role.
        The WebApplicationProxy resource specifies the name of the Federation Service for which Web
        Application Proxy provides an AD FS proxy and the thumbprint of the certificate that Web
        Application Proxy presents to users to identify the Web Application Proxy server as a proxy
        for the Federation Service.
#>

Configuration 'WebApplicationProxy_Config'
{
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'WebApplicationProxyDsc'

    Node localhost
    {
        WindowsFeature Web-Application-Proxy
        {
            Name = 'Web-Application-Proxy'
        }

        WebApplicationProxy WebApplicationProxy
        {
            FederationServiceName            = 'sts.contoso.com'
            CertificateThumbprint            = '0a1b2c3d0a1b2c3d0a1b2c3d0a1b2c3d0a1b2c3d'
            FederationServiceTrustCredential = $Credential
            DependsOn                        = '[WindowsFeature]Web-Application-Proxy'
        }
    }
}
