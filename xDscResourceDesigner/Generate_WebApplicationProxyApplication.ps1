$Module = 'WebApplicationProxy'
$ResourceName = $Module + 'Application'

$Properties = @(
    New-xDscResourceProperty `
        -Name Name `
        -Type String `
        -Attribute Key `
        -Description 'Specifies a friendly name for the published web application.'
    New-xDscResourceProperty `
        -Name ExternalUrl `
        -Type String `
        -Attribute Required `
        -Description 'Specifies the external address, as a URL, for the web application. Include the trailing slash (/).'
    New-xDscResourceProperty `
        -Name BackendServerUrl `
        -Type String `
        -Attribute Required `
        -Description 'Specifies the backend address of the web application. Specify by protocol and host name or IP address. Include the trailing slash (/). You can also include a port number and path.'
    New-xDscResourceProperty `
        -Name ADFSRelyingPartyName `
        -Type String `
        -Attribute Write `
        -Description 'Specifies the name of the relying party configured on the AD FS federation server.'
    New-xDscResourceProperty `
        -Name ADFSUserCertificateStore `
        -Type String `
        -Attribute Write `
        -Description 'Specifies the certificate store for a AD FS user.'
    New-xDscResourceProperty `
        -Name BackendServerAuthenticationSPN `
        -Type String `
        -Attribute Write `
        -Description 'Specifies the service principal name (SPN) of the backend server. Use this parameter if the application that the backend server hosts uses Integrated Windows authentication.'
    New-xDscResourceProperty `
        -Name BackendServerCertificateValidation `
        -Type String `
        -Attribute Write `
        -ValueMap 'None', 'ValidateCertificate' `
        -Values 'None', 'ValidateCertificate' `
        -Description 'Specifies whether Web Application Proxy validates the certificate that the backend server presents with the WAP configuration per application.'
    New-xDscResourceProperty `
        -Name ClientCertificateAuthenticationBindingMode `
        -Type String `
        -Attribute Write `
        -ValueMap 'None', 'ValidateCertificate' `
        -Values 'None', 'ValidateCertificate' `
        -Description 'If this parameter is set to ValidateCertificate then the browser sends a certificate with each request and validates that the device certificate thumbprint from the certificate is included in the token or the cookie.'
    New-xDscResourceProperty `
        -Name ClientCertificatePreauthenticationThumbprint `
        -Type String `
        -Attribute Write `
        -Description 'Specifies the certificate thumbprint, as a string, of the certificate that a client supplies for the preauthentication feature. The thumbprint is 40 hexadecimal characters. This parameter is only relevant when you specify the value of ClientCertificate for the ExternalPreauthentication parameter.'
    New-xDscResourceProperty `
        -Name DisableHttpOnlyCookieProtection `
        -Type Boolean `
        -Attribute Write `
        -Description 'Indicates that this resource disables the use of the HttpOnly flag when Web Application Proxy sets the access cookie. The access cookie provides single sign-on access to an application.'
    New-xDscResourceProperty `
        -Name DisableTranslateUrlInRequestHeaders `
        -Type Boolean `
        -Attribute Write `
        -Description 'Indicates that Web Application Proxy does not translate HTTP host headers from public host headers to internal host headers when it forwards the request to the published application. Specify this parameter if the application uses path-based information.'
    New-xDscResourceProperty `
        -Name DisableTranslateUrlInResponseHeaders `
        -Type Boolean `
        -Attribute Write `
        -Description 'Indicates that Web Application Proxy does not translate internal host names to public host names in Content-Location, Location, and Set-Cookie response headers in redirect responses.'
    New-xDscResourceProperty `
        -Name EnableHTTPRedirect `
        -Type Boolean `
        -Attribute Write `
        -Description 'Indicates that this resource enables HTTP redirect for Web Application Proxy.'
    New-xDscResourceProperty `
        -Name EnableSignOut `
        -Type Boolean `
        -Attribute Write `
        -Description 'Indicates whether to enable sign out for Web Application Proxy.'
    New-xDscResourceProperty `
        -Name ExternalCertificateThumbprint `
        -Type String `
        -Attribute Write `
        -Description 'Specifies the certificate thumbprint of the certificate to use for the address specified by the ExternalUrl parameter. The certificate must exist in the Local Computer or Local Personal certificate store. You can use a simple certificate, a subject alternative name (SAN) certificate, or a wildcard certificate.'
    New-xDscResourceProperty `
        -Name ExternalPreauthentication `
        -Type String `
        -Attribute Write `
        -ValueMap 'ADFS', 'ClientCertificate', 'PassThrough', 'ADFSforRichClients', 'ADFSforOAuth', 'ADFSforBrowsersAndOffice' `
        -Values 'ADFS', 'ClientCertificate', 'PassThrough', 'ADFSforRichClients', 'ADFSforOAuth', 'ADFSforBrowsersAndOffice' `
        -Description 'Specifies the preauthentication method that Web Application Proxy uses.'
    New-xDscResourceProperty `
        -Name InactiveTransactionsTimeoutSec `
        -Type UInt32 `
        -Attribute Write `
        -Description 'Specifies the length of time, in seconds, until Web Application Proxy closes incomplete HTTP transactions.'
    New-xDscResourceProperty `
        -Name PersistentAccessCookieExpirationTimeSec `
        -Type UInt32 `
        -Attribute Write `
        -Description 'Specifies the expiration time, in seconds, for persistent access cookies.'
    New-xDscResourceProperty `
        -Name UseOAuthAuthentication `
        -Type Boolean `
        -Attribute Write `
        -Description 'Indicates that Web Application Proxy provides the URL of the federation server that performs Open Authorization (OAuth) when users connect to the application by using a Windows Store app.'
    New-xDscResourceProperty `
        -Name Ensure `
        -Type String `
        -Attribute Write `
        -ValueMap 'Present', 'Absent' `
        -Values 'Present', 'Absent' `
        -Description 'Specifies whether the resource should be present or absent. Default value is ''Present''.'
)

$NewDscResourceParams = @{
    Name         = "MSFT_$ResourceName"
    Property     = $Properties
    FriendlyName = $ResourceName
    ModuleName   = $Module + 'Dsc'
    Path         = '..\..'
}

New-xDscResource @NewDscResourceParams
