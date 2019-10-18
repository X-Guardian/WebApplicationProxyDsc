<#PSScriptInfo
.VERSION 1.0.0
.GUID 19d7423e-6648-4462-a4e7-692ac51e378e
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

Configuration 'WebApplicationProxyConfiguration_Config'
{
    Import-DscResource -ModuleName 'WebApplicationProxyDsc'

    Node localhost
    {
        WebApplicationProxyConfiguration Configuration
        {
        }
    }
}
