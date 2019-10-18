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

#Requires -module 'WebApplicationProxyDsc'

<#
    .DESCRIPTION
        This configuration will ...
#>

Configuration 'WebApplicationProxyApplication_Config'
{
    Import-DscResource -ModuleName 'WebApplicationProxyDsc'

    Node localhost
    {
        WebApplicationProxy WebApplicationProxy
        {
            FederationServiceName            = 'sts.contoso.com'
            CertificateThumbprint            = '0a1b2c3d0a1b2c3d0a1b2c3d0a1b2c3d0a1b2c3d'
            FederationServiceTrustCredential = $Credential
        }
    }
}
