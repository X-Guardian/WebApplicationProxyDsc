<#PSScriptInfo
.VERSION 1.0.0
.GUID 20398705-b6b9-4f14-8402-b85835c82567
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
        This configuration will publish a web application that specifies the value of AD FS for the
        ExternalPreauthentication parameter.
#>

Configuration 'WebApplicationProxyApplication_Config'
{
    Import-DscResource -ModuleName 'WebApplicationProxyDsc'

    Node localhost
    {
        WebApplicationProxyApplication ContosoApp
        {
            Name                          = 'Contoso App'
            ExternalUrl                   = 'https://contosoapp.contoso.com'
            BackendServerUrl              = 'http://contosoapp:8080/'
            ADFSRelyingPartyName          = 'ContosoAppRP'
            ExternalCertificateThumbprint = '69DF0AB8434060DC869D37BBAEF770ED5DD0C32A'
            ExternalPreauthentication     = 'ADFS'
        }
    }
}
