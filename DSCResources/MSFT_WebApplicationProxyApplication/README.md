# Description

The WebApplicationProxyApplication DSC resource manages the publishing of a web application through Web
Application Proxy.

Use this resource to specify a name for the web application, and to provide an external address and the address
of the backend server. External clients connect to the external address to access the web application hosted by
the backend server. The resource checks the external address to verify that no other published web application
uses it on any of the proxies in the current Active Directory Federation Services (AD FS) installation.

You can specify the relying party for use with AD FS, the service principal name (SPN) of the backend server, a
certificate thumbprint for the external address, the method of preauthentication, and whether the proxy
provides the URL of the federation server to users of Open Authorization (OAuth). You can also specify whether
the application proxy validates the certificate from the backend server and verifies whether the certificate
that authenticates the federation server authenticates future requests.

The proxy can translate URLs in headers. You can disable translation in either request or response headers, or
both.

You can also specify a time-out value for inactive connections.
