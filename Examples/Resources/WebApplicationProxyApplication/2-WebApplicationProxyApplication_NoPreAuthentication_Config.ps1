<#PSScriptInfo
.VERSION 1.0.0
.GUID b349af9f-450e-4357-bc62-74c02fd694d8
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
        This configuration will publish a web application named ContosoApp. The resource specifies
        a backend server URL and an external URL. The application uses pass-through
        preauthentication.
#>

Configuration 'WebApplicationProxyApplication_NoPreAuthentication_Config'
{
    Import-DscResource -ModuleName 'WebApplicationProxyDsc'

    Node localhost
    {
        WebApplicationProxyApplication ContosoApp
        {
            Name                          = 'Contoso App'
            ExternalUrl                   = 'https://contosoapp.contoso.com'
            BackendServerUrl              = 'http://contosoapp:8080/'
            ExternalCertificateThumbprint = 'D1A657E1A4F276FCC45613C0F6B3BC91AFC4633F'
            ExternalPreauthentication     = 'PassThrough'
        }
    }
}
