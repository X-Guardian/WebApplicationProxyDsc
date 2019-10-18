$Module = 'WebApplicationProxy'
$ResourceName = $Module

$Properties = @(
    New-xDscResourceProperty `
        -Name FederationServiceName `
        -Type String `
        -Attribute Key `
        -Description 'Specifies the name of a Federation Service. This is the Federation Service for which Web Application Proxy provides AD FS proxy functionality and stores the configuration of the Federation Service.'
    New-xDscResourceProperty `
        -Name CertificateThumbprint `
        -Type String `
        -Attribute Required `
        -Description 'Specifies the certificate thumbprint of the certificate that Web Application Proxy presents to users to identify the Web Application Proxy as a proxy for the Federation Service. The certificate must be in the Personal store for the local computer. You can use a simple certificate, a subject alternative name (SAN) certificate, or a wildcard certificate.'
    New-xDscResourceProperty `
        -Name FederationServiceTrustCredential `
        -Type PSCredential `
        -Attribute Required `
        -Description 'Specifies a PSCredential object that contains the credentials of the AD FS identity that is authorized to register new Federation server proxies. Specify an account that has permissions to manage the Federation Service.'
    New-xDscResourceProperty `
        -Name ForwardProxy `
        -Type String `
        -Attribute Write `
        -Description 'Specifies the DNS name and port number of an HTTP proxy that this federation server proxy uses to obtain access to the federation service. Specify the value for this parameter in the following format: FQDN:PortNumber. Note: This parameter applies only to Federation Services proxy. It does not apply for application publishing.'
    New-xDscResourceProperty `
        -Name HttpsPort `
        -Type Sint32 `
        -Attribute Write `
        -Description 'Specifies the HTTPS port for the Web Application Proxy server. The default value is 443.'
    New-xDscResourceProperty `
        -Name TlsClientPort `
        -Type Sint32 `
        -Attribute Write `
        -Description 'Specifies the port for the TLS client. Web Application Proxy uses this port for user certificate authentication. The default value is 49443.'
)

$NewDscResourceParams = @{
    Name         = "MSFT_$ResourceName"
    Property     = $Properties
    FriendlyName = $ResourceName
    ModuleName   = $Module + 'Dsc'
    Path         = '..\..'
}

New-xDscResource @NewDscResourceParams
