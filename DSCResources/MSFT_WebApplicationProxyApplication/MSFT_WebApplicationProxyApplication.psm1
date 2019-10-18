<#
    .SYNOPSIS
        DSC module for the Web Application Proxy Proxy Application resource

    .DESCRIPTION
#>

Set-StrictMode -Version 2.0

$script:dscModuleName = 'WebApplicationProxyDsc'
$script:PSModuleName = 'WebApplicationProxy'
$script:dscResourceName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)

$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath "$($script:DSCModuleName).Common"
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath "$($script:dscModuleName).Common.psm1")

$script:localizedData = Get-LocalizedData -ResourceName $script:dscResourceName

function Get-TargetResource
{
    <#
    .SYNOPSIS
        Get-TargetResource

    .NOTES
        Used Resource PowerShell Cmdlets:
        - Get-WebApplicationProxyApplication - https://docs.microsoft.com/en-us/powershell/module/webapplicationproxy/get-webapplicationproxyapplication
    #>

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ExternalUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $BackendServerUrl
    )

    # Check of the WebApplicationProxy PowerShell module is installed
    Assert-Module -ModuleName $script:PSModuleName

    Write-Verbose ($script:localizedData.GettingResourceMessage -f $Name)

    $targetResource = Get-WebApplicationProxyApplication -Name $Name

    if ($targetResource)
    {
        # Resource exists
        $returnValue = @{
            Name                                         = $targetResource.Name
            ExternalUrl                                  = $targetResource.ExternalUrl
            BackendServerUrl                             = $targetResource.BackendServerUrl
            ADFSRelyingPartyName                         = $targetResource.ADFSRelyingPartyName
            ADFSUserCertificateStore                     = $targetResource.ADFSUserCertificateStore
            BackendServerAuthenticationSPN               = $targetResource.BackendServerAuthenticationSPN
            BackendServerCertificateValidation           = $targetResource.BackendServerCertificateValidation
            ClientCertificateAuthenticationBindingMode   = $targetResource.ClientCertificateAuthenticationBindingMode
            ClientCertificatePreauthenticationThumbprint = $targetResource.ClientCertificatePreauthenticationThumbprint
            DisableHttpOnlyCookieProtection              = $targetResource.DisableHttpOnlyCookieProtection
            DisableTranslateUrlInRequestHeaders          = $targetResource.DisableTranslateUrlInRequestHeaders
            DisableTranslateUrlInResponseHeaders         = $targetResource.DisableTranslateUrlInResponseHeaders
            EnableHTTPRedirect                           = $targetResource.EnableHTTPRedirect
            EnableSignOut                                = $targetResource.EnableSignOut
            ExternalCertificateThumbprint                = $targetResource.ExternalCertificateThumbprint
            ExternalPreauthentication                    = $targetResource.ExternalPreauthentication
            InactiveTransactionsTimeoutSec               = $targetResource.InactiveTransactionsTimeoutSec
            PersistentAccessCookieExpirationTimeSec      = $targetResource.PersistentAccessCookieExpirationTimeSec
            UseOAuthAuthentication                       = $targetResource.UseOAuthAuthentication
            Id                                           = $targetResource.Id
            Ensure                                       = 'Present'
        }
    }
    else
    {
        # Resource does not exist
        $returnValue = @{
            Name                                         = $Name
            ExternalUrl                                  = $ExternalUrl
            BackendServerUrl                             = $BackendServerUrl
            ADFSRelyingPartyName                         = $null
            ADFSUserCertificateStore                     = $null
            BackendServerAuthenticationSPN               = $null
            BackendServerCertificateValidation           = 'None'
            ClientCertificateAuthenticationBindingMode   = 'none'
            ClientCertificatePreauthenticationThumbprint = $null
            DisableHttpOnlyCookieProtection              = $false
            DisableTranslateUrlInRequestHeaders          = $false
            DisableTranslateUrlInResponseHeaders         = $false
            EnableHTTPRedirect                           = $false
            EnableSignOut                                = $false
            ExternalCertificateThumbprint                = $null
            ExternalPreauthentication                    = 'PassThrough'
            InactiveTransactionsTimeoutSec               = $null
            PersistentAccessCookieExpirationTimeSec      = $null
            UseOAuthAuthentication                       = $false
            Id                                           = $null
            Ensure                                       = 'Absent'
        }
    }

    $returnValue
}


function Set-TargetResource
{
    <#
    .SYNOPSIS
        Set-TargetResource

    .NOTES
        Used Resource PowerShell Cmdlets:
        - Add-WebApplicationProxyApplication - https://docs.microsoft.com/en-us/powershell/module/webapplicationproxy/add-webapplicationproxyapplication
        - Set-WebApplicationProxyApplication - https://docs.microsoft.com/en-us/powershell/module/webapplicationproxy/set-webapplicationproxyapplication
        - Remove-WebApplicationProxyApplication - https://docs.microsoft.com/en-us/powershell/module/webapplicationproxy/remove-webapplicationproxyapplication
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ExternalUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $BackendServerUrl,

        [Parameter()]
        [System.String]
        $ADFSRelyingPartyName,

        [Parameter()]
        [System.String]
        $ADFSUserCertificateStore,

        [Parameter()]
        [System.String]
        $BackendServerAuthenticationSPN,

        [Parameter()]
        [ValidateSet('None', 'ValidateCertificate')]
        [System.String]
        $BackendServerCertificateValidation,

        [Parameter()]
        [ValidateSet('None', 'ValidateCertificate')]
        [System.String]
        $ClientCertificateAuthenticationBindingMode,

        [Parameter()]
        [System.String]
        $ClientCertificatePreauthenticationThumbprint,

        [Parameter()]
        [System.Boolean]
        $DisableHttpOnlyCookieProtection,

        [Parameter()]
        [System.Boolean]
        $DisableTranslateUrlInRequestHeaders,

        [Parameter()]
        [System.Boolean]
        $DisableTranslateUrlInResponseHeaders,

        [Parameter()]
        [System.Boolean]
        $EnableHTTPRedirect,

        [Parameter()]
        [System.Boolean]
        $EnableSignOut,

        [Parameter()]
        [System.String]
        $ExternalCertificateThumbprint,

        [Parameter()]
        [ValidateSet('ADFS', 'ClientCertificate', 'PassThrough', 'ADFSforRichClients', 'ADFSforOAuth', 'ADFSforBrowsersAndOffice')]
        [System.String]
        $ExternalPreauthentication,

        [Parameter()]
        [System.UInt32]
        $InactiveTransactionsTimeoutSec,

        [Parameter()]
        [System.UInt32]
        $PersistentAccessCookieExpirationTimeSec,

        [Parameter()]
        [System.Boolean]
        $UseOAuthAuthentication,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure
    )

    # Remove any parameters not used in Splats
    $parameters = $PSBoundParameters
    $parameters.Remove('Ensure')
    $parameters.Remove('Verbose')

    $getTargetResourceParms = @{
        Name             = $Name
        ExternalUrl      = $ExternalUrl
        BackendServerUrl = $BackendServerUrl
    }
    $targetResource = Get-TargetResource @getTargetResourceParms

    if ($Ensure -eq 'Present')
    {
        # Resource should exist
        if ($TargetResource.Ensure -eq 'Present')
        {
            # Resource exists
            $createNewResource = $false
            $propertiesNotInDesiredState = (
                Compare-ResourcePropertyState -CurrentValues $targetResource -DesiredValues $parameters |
                    Where-Object -Property InDesiredState -eq $false)

            if ($propertiesNotInDesiredState)
            {
                if ($propertiesNotInDesiredState.ParameterName -contains 'ADFSRelyingPartyName' -or
                    $propertiesNotInDesiredState.ParameterName -contains 'ExternalPreauthentication')
                {
                    # ADFSRelyingPartyName or ExternalPreauthentication has changed, so the resource needs recreating
                    Write-Verbose -Message ($script:localizedData.RecreatingResourceMessage -f $Name)
                    try
                    {
                        Write-Verbose -Message ($script:localizedData.RemovingResourceMessage -f $Name)
                        Remove-WebApplicationProxyApplication -Name $Name
                    }
                    catch
                    {
                        $errorMessage = $script:localizedData.RemovingResourceError -f $Name
                        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
                    }

                    $createNewResource = $true
                }
                else
                {
                    $SetParameters = New-Object -TypeName System.Collections.Hashtable
                    foreach ($property in $propertiesNotInDesiredState)
                    {
                        Write-Verbose -Message ($script:localizedData.SettingResourceMessage -f
                            $Name, $property.ParameterName, ($property.Expected -join ', '))
                        $SetParameters.add($property.ParameterName, $property.Expected)
                    }

                    Set-WebApplicationProxyApplication -Id $targetResource.Id @SetParameters
                }
            }
        }
        else
        {
            # Resource does not exist
            $createNewResource = $true
        }

        if ($createNewResource)
        {
            Write-Verbose -Message ($script:localizedData.AddingResourceMessage -f $Name)
            Add-WebApplicationProxyApplication @parameters
        }
    }
    else
    {
        # Resource should not exist
        if ($TargetResource.Ensure -eq 'Present')
        {
            # Resource exists
            Write-Verbose -Message ($script:localizedData.RemovingResourceMessage -f $Name)
            Remove-WebApplicationProxyApplication -Name $Name
        }
        else
        {
            # Resource does not exist
            Write-Verbose -Message ($script:localizedData.ResourceInDesiredStateMessage -f $Name)
        }
    }
}


function Test-TargetResource
{
    <#
    .SYNOPSIS
        Test-TargetResource
    #>

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ExternalUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $BackendServerUrl,

        [Parameter()]
        [System.String]
        $ADFSRelyingPartyName,

        [Parameter()]
        [System.String]
        $ADFSUserCertificateStore,

        [Parameter()]
        [System.String]
        $BackendServerAuthenticationSPN,

        [Parameter()]
        [ValidateSet('None', 'ValidateCertificate')]
        [System.String]
        $BackendServerCertificateValidation,

        [Parameter()]
        [ValidateSet('None', 'ValidateCertificate')]
        [System.String]
        $ClientCertificateAuthenticationBindingMode,

        [Parameter()]
        [System.String]
        $ClientCertificatePreauthenticationThumbprint,

        [Parameter()]
        [System.Boolean]
        $DisableHttpOnlyCookieProtection,

        [Parameter()]
        [System.Boolean]
        $DisableTranslateUrlInRequestHeaders,

        [Parameter()]
        [System.Boolean]
        $DisableTranslateUrlInResponseHeaders,

        [Parameter()]
        [System.Boolean]
        $EnableHTTPRedirect,

        [Parameter()]
        [System.Boolean]
        $EnableSignOut,

        [Parameter()]
        [System.String]
        $ExternalCertificateThumbprint,

        [Parameter()]
        [ValidateSet('ADFS', 'ClientCertificate', 'PassThrough', 'ADFSforRichClients', 'ADFSforOAuth', 'ADFSforBrowsersAndOffice')]
        [System.String]
        $ExternalPreauthentication,

        [Parameter()]
        [System.UInt32]
        $InactiveTransactionsTimeoutSec,

        [Parameter()]
        [System.UInt32]
        $PersistentAccessCookieExpirationTimeSec,

        [Parameter()]
        [System.Boolean]
        $UseOAuthAuthentication,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure
    )

    $GetTargetResourceParms = @{
        Name             = $Name
        ExternalUrl      = $ExternalUrl
        BackendServerUrl = $BackendServerUrl
    }
    $targetResource = Get-TargetResource @GetTargetResourceParms

    if ($targetResource.Ensure -eq 'Present')
    {
        # Resource exists
        if ($Ensure -eq 'Present')
        {
            # Resource should exist
            $propertiesNotInDesiredState = (
                Compare-ResourcePropertyState -CurrentValues $targetResource -DesiredValues $PSBoundParameters |
                    Where-Object -Property InDesiredState -eq $false)
            if ($propertiesNotInDesiredState)
            {
                # Resource is not in desired state
                foreach ($property in $propertiesNotInDesiredState)
                {
                    Write-Verbose -Message ($script:localizedData.ResourcePropertyNotInDesiredStateMessage -f
                        $targetResource.Name, $property.ParameterName)
                }
                $inDesiredState = $false
            }
            else
            {
                # Resource is in desired state
                Write-Verbose -Message ($script:localizedData.ResourceInDesiredStateMessage -f
                    $targetResource.Name)
                $inDesiredState = $true
            }
        }
        else
        {
            # Resource should not exist
            Write-Verbose -Message ($script:localizedData.ResourceExistsButShouldNotMessage -f
                $targetResource.Name)
            $inDesiredState = $false
        }
    }
    else
    {
        # Resource does not exist
        if ($Ensure -eq 'Present')
        {
            # Resource should exist
            Write-Verbose -Message ($script:localizedData.ResourceDoesNotExistButShouldMessage -f
                $targetResource.Name)
            $inDesiredState = $false
        }
        else
        {
            # Resource should not exist
            Write-Verbose ($script:localizedData.ResourceDoesNotExistAndShouldNotMessage -f
                $targetResource.Name)
            $inDesiredState = $true
        }
    }

    $inDesiredState
}

Export-ModuleMember -Function *-TargetResource
