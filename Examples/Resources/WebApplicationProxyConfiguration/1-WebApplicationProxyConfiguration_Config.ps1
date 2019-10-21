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
            FederationServiceName                  = 'sts.contoso.com'
            ADFSSignOutUrl                         = 'https://sts.contoso.com/adfs/ls/?wa=wsignout1.0'
            ADFSTokenAcceptanceDurationSec         = 120
            ADFSTokenSigningCertificatePublicKey   = '0a1b2c3d0a1b2c3d0a1b2c3d0a1b2c3d0a1b2c3d'
            ADFSUrl                                = 'https://sts.contoso.com/adfs/ls'
            ADFSWebApplicationProxyRelyingPartyUri = 'urn:AppProxy:com'
            ConfigurationChangesPollingIntervalSec = 30
            ConnectedServersName                   = 'wap01.contoso.com'
            OAuthAuthenticationURL                 = 'https://sts.contoso.com/adfs/oauth2/authorize'
            UserIdleTimeoutAction                  = 'Signout'
            UserIdleTimeoutSec                     = 0
        }
    }
}
