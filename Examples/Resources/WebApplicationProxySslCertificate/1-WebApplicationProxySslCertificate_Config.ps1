<#PSScriptInfo
.VERSION 1.0.0
.GUID 51fed50d-10b3-4054-9386-8af6d320a6fe
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

#Requires -module AdfsDsc

<#
    .DESCRIPTION
        This configuration will ...
#>

Configuration WebApplicationProxySslCertificate_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName WebApplicationProxyDsc

    Node localhost
    {
        WebApplicationProxySslCertificate SslCertificate
        {
            CertificateType = 'Https-Binding'
            Thumbprint      = 'cb779e674ae6921682d01d055a4315c786160a7b'
        }
    }
}
