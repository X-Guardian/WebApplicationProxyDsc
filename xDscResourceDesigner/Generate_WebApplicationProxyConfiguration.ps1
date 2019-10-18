$Module = 'WebApplicationProxy'
$ResourceName = $Module + 'Configuration'

$Properties = @(
    New-xDscResourceProperty `
        -Name FederationServiceName `
        -Type String `
        -Attribute Key `
        -Description 'Specifies the name of a Federation Service. This is the Federation Service for which Web Application Proxy provides AD FS proxy functionality and stores the configuration of the Federation Service.'
    New-xDscResourceProperty `
        -Name ADFSSignOutURL `
        -Type String `
        -Attribute Write `
        -Description 'Specifies the sign out URL for Web Application Proxy.'
    New-xDscResourceProperty `
        -Name ADFSTokenAcceptanceDurationSec `
        -Type UInt32 `
        -Attribute Write `
        -Description ''
    New-xDscResourceProperty `
        -Name ADFSTokenSigningCertificatePublicKey `
        -Type String `
        -Attribute Write `
        -Description 'Specifies the thumbprint of the certificate that the federation server uses to sign the edge token. Specify this parameter only when the AD FS token signing certificate changes.'
    New-xDscResourceProperty `
        -Name ADFSUrl `
        -Type String `
        -Attribute Write `
        -Description 'Specifies the URL for the federation server that is used by the Web Application Proxy.'
    New-xDscResourceProperty `
        -Name ADFSWebApplicationProxyRelyingPartyUri `
        -Type String `
        -Attribute Write `
        -Description 'Specifies the URI for the Web Application Proxy server.'
    New-xDscResourceProperty `
        -Name ConfigurationChangesPollingIntervalSec `
        -Type UInt32 `
        -Attribute Write `
        -Description 'Specifies the time interval, in seconds, that elapses before the Web Application Proxy servers query a federation server for configuration changes.'
    New-xDscResourceProperty `
        -Name ConnectedServersName `
        -Type String[] `
        -Attribute Write `
        -Description 'Specifies an array of Web Application Proxy servers that are connected to a federation server.'
    New-xDscResourceProperty `
        -Name OAuthAuthenticationURL `
        -Type String `
        -Attribute Write `
        -Description 'Specifies the URL of the federation server that performs Open Authorization (OAuth) authentication when end users connect to a published web application using a Windows Store app.'
    New-xDscResourceProperty `
        -Name UserIdleTimeoutAction `
        -Type String `
        -Attribute Write `
        -ValueMap 'Signout', 'Reauthenticate' `
        -Values 'Signout', 'Reauthenticate' `
        -Description 'Write Property.'
    New-xDscResourceProperty `
        -Name UserIdleTimeoutSec `
        -Type UInt32 `
        -Attribute Write `
        -Description ''
)

$NewDscResourceParams = @{
    Name         = "MSFT_$ResourceName"
    Property     = $Properties
    FriendlyName = $ResourceName
    ModuleName   = $Module + 'Dsc'
    Path         = '..\..'
}

New-xDscResource @NewDscResourceParams
