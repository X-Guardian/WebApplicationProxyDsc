$Global:DSCModuleName = 'WebApplicationProxyDsc'
$Global:PSModuleName = 'WebApplicationProxy'
$Global:DscResourceFriendlyName = 'WebApplicationProxyApplication'
$Global:DSCResourceName = "MSFT_$Global:DscResourceFriendlyName"

$moduleRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $Script:MyInvocation.MyCommand.Path))
if ( (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
    (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git',
        (Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'))
}

Import-Module (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force

$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $Global:DSCModuleName `
    -DSCResourceName $Global:DSCResourceName `
    -TestType Unit

try
{
    InModuleScope $Global:DSCResourceName {
        # Import Stub Module
        Import-Module (Join-Path -Path $PSScriptRoot -ChildPath "Stubs\$($Global:PSModuleName)Stub.psm1") -Force

        # Define Resource Commands
        $ResourceCommand = @{
            Get    = 'Get-WebApplicationProxyApplication'
            Set    = 'Set-WebApplicationProxyApplication'
            Add    = 'Add-WebApplicationProxyApplication'
            Remove = 'Remove-WebApplicationProxyApplication'
        }

        $mockResource = @{
            Name                                         = 'Contoso App'
            ExternalUrl                                  = 'https://contosoapp.contoso.com'
            BackendServerUrl                             = 'http://contosoapp:8080/'
            ADFSRelyingPartyName                         = 'ContosoAppRP'
            ADFSUserCertificateStore                     = ''
            BackendServerAuthenticationSPN               = ''
            BackendServerCertificateValidation           = 'None'
            ClientCertificateAuthenticationBindingMode   = 'None'
            ClientCertificatePreauthenticationThumbprint = ''
            DisableHttpOnlyCookieProtection              = $false
            DisableTranslateUrlInRequestHeaders          = $false
            DisableTranslateUrlInResponseHeaders         = $false
            EnableHTTPRedirect                           = $false
            EnableSignOut                                = $false
            ExternalCertificateThumbprint                = '69DF0AB8434060DC869D37BBAEF770ED5DD0C32A'
            ExternalPreauthentication                    = 'ADFS'
            InactiveTransactionsTimeoutSec               = 300
            PersistentAccessCookieExpirationTimeSec      = 0
            UseOAuthAuthentication                       = $false
            Id                                           = '05E6680E-52B4-05E2-8F83-6EA2A76C7CE7'
            Ensure                                       = 'Present'
        }

        $mockAbsentResource = @{
            Name                                         = $mockResource.Name
            ExternalUrl                                  = $mockResource.ExternalUrl
            BackendServerUrl                             = $mockResource.BackendServerUrl
            ADFSRelyingPartyName                         = $null
            ADFSUserCertificateStore                     = $null
            BackendServerAuthenticationSPN               = $null
            BackendServerCertificateValidation           = 'None'
            ClientCertificateAuthenticationBindingMode   = 'None'
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

        $mockChangedResource = @{
            ExternalUrl                                  = 'https://fabrikamapp.fabrikam.com'
            BackendServerUrl                             = 'http://fabrikamapp:8080/'
            ADFSUserCertificateStore                     = 'My'
            BackendServerAuthenticationSPN               = 'HOST/fabrikamapp'
            BackendServerCertificateValidation           = 'ValidateCertificate'
            ClientCertificateAuthenticationBindingMode   = 'ValidateCertificate'
            ClientCertificatePreauthenticationThumbprint = '69DF0AB8434060DC869D37BBAEF770ED5DD0C32C'
            DisableHttpOnlyCookieProtection              = $true
            DisableTranslateUrlInRequestHeaders          = $true
            DisableTranslateUrlInResponseHeaders         = $true
            EnableHTTPRedirect                           = $true
            EnableSignOut                                = $true
            ExternalCertificateThumbprint                = '69DF0AB8434060DC869D37BBAEF770ED5DD0C32B'
            InactiveTransactionsTimeoutSec               = 600
            PersistentAccessCookieExpirationTimeSec      = 100
            UseOAuthAuthentication                       = $true
        }

        $mockChangedADFSRelyingPartyName = 'FabrikamAppRp'
        $mockChangedExternalPreauthentication = 'Passthrough'

        $mockGetTargetResourceResult = @{
            Name                                         = $mockResource.Name
            ExternalUrl                                  = $mockResource.ExternalUrl
            BackendServerUrl                             = $mockResource.BackendServerUrl
            ADFSRelyingPartyName                         = $mockResource.ADFSRelyingPartyName
            ADFSUserCertificateStore                     = $mockResource.ADFSUserCertificateStore
            BackendServerAuthenticationSPN               = $mockResource.BackendServerAuthenticationSPN
            BackendServerCertificateValidation           = $mockResource.BackendServerCertificateValidation
            ClientCertificateAuthenticationBindingMode   = $mockResource.ClientCertificateAuthenticationBindingMode
            ClientCertificatePreauthenticationThumbprint = $mockResource.ClientCertificatePreauthenticationThumbprint
            DisableHttpOnlyCookieProtection              = $mockResource.DisableHttpOnlyCookieProtection
            DisableTranslateUrlInRequestHeaders          = $mockResource.DisableTranslateUrlInRequestHeaders
            DisableTranslateUrlInResponseHeaders         = $mockResource.DisableTranslateUrlInResponseHeaders
            EnableHTTPRedirect                           = $mockResource.EnableHTTPRedirect
            EnableSignOut                                = $mockResource.EnableSignOut
            ExternalCertificateThumbprint                = $mockResource.ExternalCertificateThumbprint
            ExternalPreauthentication                    = $mockResource.ExternalPreauthentication
            InactiveTransactionsTimeoutSec               = $mockResource.InactiveTransactionsTimeoutSec
            PersistentAccessCookieExpirationTimeSec      = $mockResource.PersistentAccessCookieExpirationTimeSec
            UseOAuthAuthentication                       = $mockResource.UseOAuthAuthentication
            Id                                           = $mockResource.Id
        }

        $mockGetTargetResourcePresentResult = $mockGetTargetResourceResult.Clone()
        $mockGetTargetResourcePresentResult.Ensure = 'Present'

        $mockGetTargetResourceAbsentResult = $mockGetTargetResourceResult.Clone()
        $mockGetTargetResourceAbsentResult.Ensure = 'Absent'

        Describe "$Global:DSCResourceName\Get-TargetResource" -Tag 'Get' {
            BeforeAll {
                $getTargetResourceParameters = @{
                    Name             = $mockResource.Name
                    ExternalUrl      = $mockResource.ExternalUrl
                    BackendServerUrl = $mockResource.BackendServerUrl
                }

                $mockGetResourceCommandResult = @{
                    Name                                         = $mockResource.Name
                    ExternalUrl                                  = $mockResource.ExternalUrl
                    BackendServerUrl                             = $mockResource.BackendServerUrl
                    ADFSRelyingPartyName                         = $mockResource.ADFSRelyingPartyName
                    ADFSUserCertificateStore                     = $mockResource.ADFSUserCertificateStore
                    BackendServerAuthenticationSPN               = $mockResource.BackendServerAuthenticationSPN
                    BackendServerCertificateValidation           = $mockResource.BackendServerCertificateValidation
                    ClientCertificateAuthenticationBindingMode   = $mockResource.ClientCertificateAuthenticationBindingMode
                    ClientCertificatePreauthenticationThumbprint = $mockResource.ClientCertificatePreauthenticationThumbprint
                    DisableHttpOnlyCookieProtection              = $mockResource.DisableHttpOnlyCookieProtection
                    DisableTranslateUrlInRequestHeaders          = $mockResource.DisableTranslateUrlInRequestHeaders
                    DisableTranslateUrlInResponseHeaders         = $mockResource.DisableTranslateUrlInResponseHeaders
                    EnableHTTPRedirect                           = $mockResource.EnableHTTPRedirect
                    EnableSignOut                                = $mockResource.EnableSignOut
                    ExternalCertificateThumbprint                = $mockResource.ExternalCertificateThumbprint
                    ExternalPreauthentication                    = $mockResource.ExternalPreauthentication
                    InactiveTransactionsTimeoutSec               = $mockResource.InactiveTransactionsTimeoutSec
                    PersistentAccessCookieExpirationTimeSec      = $mockResource.PersistentAccessCookieExpirationTimeSec
                    UseOAuthAuthentication                       = $mockResource.UseOAuthAuthentication
                    Id                                           = $mockResource.Id
                }

                Mock -CommandName Assert-Module
            }

            Context 'When the Resource is Present' {
                BeforeAll {
                    Mock -CommandName $ResourceCommand.Get -MockWith { $mockGetResourceCommandResult }

                    $result = Get-TargetResource @getTargetResourceParameters
                }

                foreach ($property in $mockResource.Keys)
                {
                    It "Should return the correct $property property" {
                        $result.$property | Should -Be $mockResource.$property
                    }
                }

                It 'Should call the expected mocks' {
                    Assert-MockCalled -CommandName Assert-Module `
                        -ParameterFilter { $ModuleName -eq $Global:PSModuleName } `
                        -Exactly -Times 1
                    Assert-MockCalled -CommandName $ResourceCommand.Get `
                        -ParameterFilter { `
                            $Name -eq $getTargetResourceParameters.Name } `
                        -Exactly -Times 1
                }
            }

            Context 'When the Resource is Absent' {
                BeforeAll {
                    Mock -CommandName $ResourceCommand.Get

                    $result = Get-TargetResource @getTargetResourceParameters
                }

                foreach ($property in $mockAbsentResource.Keys)
                {
                    It "Should return the correct $property property" {
                        $result.$property | Should -Be $mockAbsentResource.$property
                    }
                }

                It 'Should call the expected mocks' {
                    Assert-MockCalled -CommandName Assert-Module `
                        -ParameterFilter { $ModuleName -eq $Global:PSModuleName } `
                        -Exactly -Times 1
                    Assert-MockCalled -CommandName $ResourceCommand.Get `
                        -ParameterFilter { `
                            $Name -eq $getTargetResourceParameters.Name } `
                        -Exactly -Times 1
                }
            }
        }

        Describe "$Global:DSCResourceName\Set-TargetResource" -Tag 'Set' {
            BeforeAll {
                $setTargetResourceParameters = @{
                    Name                                         = $mockResource.Name
                    ExternalUrl                                  = $mockResource.ExternalUrl
                    BackendServerUrl                             = $mockResource.BackendServerUrl
                    ADFSRelyingPartyName                         = $mockResource.ADFSRelyingPartyName
                    ADFSUserCertificateStore                     = $mockResource.ADFSUserCertificateStore
                    BackendServerAuthenticationSPN               = $mockResource.BackendServerAuthenticationSPN
                    BackendServerCertificateValidation           = $mockResource.BackendServerCertificateValidation
                    ClientCertificateAuthenticationBindingMode   = $mockResource.ClientCertificateAuthenticationBindingMode
                    ClientCertificatePreauthenticationThumbprint = $mockResource.ClientCertificatePreauthenticationThumbprint
                    DisableHttpOnlyCookieProtection              = $mockResource.DisableHttpOnlyCookieProtection
                    DisableTranslateUrlInRequestHeaders          = $mockResource.DisableTranslateUrlInRequestHeaders
                    DisableTranslateUrlInResponseHeaders         = $mockResource.DisableTranslateUrlInResponseHeaders
                    EnableHTTPRedirect                           = $mockResource.EnableHTTPRedirect
                    EnableSignOut                                = $mockResource.EnableSignOut
                    ExternalCertificateThumbprint                = $mockResource.ExternalCertificateThumbprint
                    ExternalPreauthentication                    = $mockResource.ExternalPreauthentication
                    InactiveTransactionsTimeoutSec               = $mockResource.InactiveTransactionsTimeoutSec
                    PersistentAccessCookieExpirationTimeSec      = $mockResource.PersistentAccessCookieExpirationTimeSec
                    UseOAuthAuthentication                       = $mockResource.UseOAuthAuthentication
                }

                $setTargetResourcePresentParameters = $setTargetResourceParameters.Clone()
                $setTargetResourcePresentParameters.Ensure = 'Present'

                $setTargetResourceAbsentParameters = $setTargetResourceParameters.Clone()
                $setTargetResourceAbsentParameters.Ensure = 'Absent'

                Mock -CommandName $ResourceCommand.Set
                Mock -CommandName $ResourceCommand.Add
                Mock -CommandName $ResourceCommand.Remove
            }

            Context 'When the Resource is Present' {
                BeforeAll {
                    Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourcePresentResult }
                }

                Context 'When the Resource should be Present' {
                    foreach ($property in $mockChangedResource.Keys)
                    {
                        Context "When $property has changed" {
                            BeforeAll {
                                $setTargetResourceParametersChangedProperty = $setTargetResourcePresentParameters.Clone()
                                $setTargetResourceParametersChangedProperty.$property = $mockChangedResource.$property
                            }

                            It 'Should not throw' {
                                { Set-TargetResource @setTargetResourceParametersChangedProperty } | Should -Not -Throw
                            }

                            It 'Should call the correct mocks' {
                                Assert-MockCalled -CommandName Get-TargetResource `
                                    -ParameterFilter { `
                                        $Name -eq $setTargetResourceParametersChangedProperty.Name -and `
                                        $ExternalUrl -eq $setTargetResourceParametersChangedProperty.ExternalUrl -and `
                                        $BackendServerUrl -eq $setTargetResourceParametersChangedProperty.BackendServerUrl } `
                                    -Exactly -Times 1
                                Assert-MockCalled -CommandName $ResourceCommand.Set `
                                    -ParameterFilter { $Id -eq $mockGetTargetResourcePresentResult.Id } `
                                    -Exactly -Times 1
                                Assert-MockCalled -CommandName $ResourceCommand.Add -Exactly -Times 0
                                Assert-MockCalled -CommandName $ResourceCommand.Remove -Exactly -Times 0
                            }
                        }
                    }

                    Context 'When ADFSRelyingPartyName has changed' {
                        $setTargetResourceParametersChangedRelyingParty = $setTargetResourcePresentParameters.Clone()
                        $setTargetResourceParametersChangedRelyingParty.ADFSRelyingPartyName = `
                            $mockChangedADFSRelyingPartyName

                        It 'Should not throw' {
                            { Set-TargetResource @setTargetResourceParametersChangedRelyingParty }  | Should -Not -Throw
                        }

                        It 'Should call the correct mocks' {
                            Assert-MockCalled -CommandName Get-TargetResource `
                                -ParameterFilter { `
                                    $Name -eq $setTargetResourceParametersChangedRelyingParty.Name -and `
                                    $ExternalUrl -eq $setTargetResourceParametersChangedRelyingParty.ExternalUrl -and `
                                    $BackendServerUrl -eq $setTargetResourceParametersChangedRelyingParty.BackendServerUrl } `
                                -Exactly -Times 1
                            Assert-MockCalled -CommandName $ResourceCommand.Add `
                                -ParameterFilter { `
                                    $Name -eq $setTargetResourceParametersChangedRelyingParty.Name } `
                                -Exactly -Times 1
                            Assert-MockCalled -CommandName $ResourceCommand.Remove `
                                -ParameterFilter { `
                                    $Name -eq $setTargetResourceParametersChangedRelyingParty.Name } `
                                -Exactly -Times 1
                            Assert-MockCalled -CommandName $ResourceCommand.Set -Exactly -Times 0
                        }

                        Context "When $($ResourceCommand.Remove) throws an exception" {
                            BeforeAll {
                                Mock -CommandName $ResourceCommand.Remove -MockWith { Throw 'Error' }
                            }

                            It 'Should throw the correct exception' {
                                { Set-TargetResource @setTargetResourceParametersChangedRelyingParty } | Should -Throw (
                                    $script:localizedData.RemovingResourceError -f `
                                        $setTargetResourceParametersChangedRelyingParty.Name )
                            }
                        }
                    }

                    Context 'When ExternalPreauthentication has changed' {
                        $setTargetResourceParametersChangedPreauthentication = `
                            $setTargetResourcePresentParameters.Clone()
                        $setTargetResourceParametersChangedPreauthentication.ExternalPreauthentication = `
                            $mockChangedExternalPreauthentication

                        It 'Should not throw' {
                            { Set-TargetResource @setTargetResourceParametersChangedPreauthentication } | `
                                    Should -Not -Throw
                        }

                        It 'Should call the correct mocks' {
                            Assert-MockCalled -CommandName Get-TargetResource `
                                -ParameterFilter { `
                                    $Name -eq $setTargetResourceParametersChangedPreauthentication.Name } `
                                -Exactly -Times 1
                            Assert-MockCalled -CommandName $ResourceCommand.Add `
                                -ParameterFilter { `
                                    $Name -eq $setTargetResourceParametersChangedPreauthentication.Name } `
                                -Exactly -Times 1
                            Assert-MockCalled -CommandName $ResourceCommand.Remove `
                                -ParameterFilter { `
                                    $Name -eq $setTargetResourceParametersChangedPreauthentication.Name } `
                                -Exactly -Times 1
                            Assert-MockCalled -CommandName $ResourceCommand.Set -Exactly -Times 0
                        }

                        Context "When $($ResourceCommand.Remove) throws an exception" {
                            BeforeAll {
                                Mock -CommandName $ResourceCommand.Remove -MockWith { Throw 'Error' }
                            }

                            It 'Should throw the correct exception' {
                                { Set-TargetResource @setTargetResourceParametersChangedPreauthentication } | Should -Throw (
                                    $script:localizedData.RemovingResourceError -f `
                                        $setTargetResourceParametersChangedPreauthentication.Name )
                            }
                        }
                    }
                }

                Context 'When the Resource should be Absent' {
                    It 'Should not throw' {
                        { Set-TargetResource @setTargetResourceAbsentParameters } | Should -Not -Throw
                    }
                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { `
                                $Name -eq $setTargetResourceAbsentParameters.Name -and `
                                $ExternalUrl -eq $setTargetResourceAbsentParameters.ExternalUrl -and `
                                $BackendServerUrl -eq $setTargetResourceAbsentParameters.BackendServerUrl } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Remove `
                            -ParameterFilter { $Name -eq $setTargetResourceAbsentParameters.Name } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Set -Exactly -Times 0
                        Assert-MockCalled -CommandName $ResourceCommand.Add -Exactly -Times 0
                    }
                }
            }

            Context 'When the Resource is Absent' {
                BeforeAll {
                    Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourceAbsentResult }
                }

                Context 'When the Resource should be Present' {
                    It 'Should not throw' {
                        { Set-TargetResource @setTargetResourcePresentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { `
                                $Name -eq $setTargetResourcePresentParameters.Name -and `
                                $ExternalUrl -eq $setTargetResourcePresentParameters.ExternalUrl -and `
                                $BackendServerUrl -eq $setTargetResourcePresentParameters.BackendServerUrl } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Add `
                            -ParameterFilter { `
                                $Name -eq $setTargetResourcePresentParameters.Name -and `
                                $ExternalUrl -eq $setTargetResourcePresentParameters.ExternalUrl -and `
                                $BackendServerUrl -eq $setTargetResourcePresentParameters.BackendServerUrl } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Set -Exactly -Times 0
                        Assert-MockCalled -CommandName $ResourceCommand.Remove -Exactly -Times 0
                    }
                }

                Context 'When the Resource should be Absent' {
                    It 'Should not throw' {
                        { Set-TargetResource @setTargetResourceAbsentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { `
                                $Name -eq $setTargetResourceAbsentParameters.Name -and `
                                $ExternalUrl -eq $setTargetResourceAbsentParameters.ExternalUrl -and `
                                $BackendServerUrl -eq $setTargetResourceAbsentParameters.BackendServerUrl } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Remove -Exactly -Times 0
                        Assert-MockCalled -CommandName $ResourceCommand.Add -Exactly -Times 0
                        Assert-MockCalled -CommandName $ResourceCommand.Set -Exactly -Times 0
                    }
                }
            }
        }

        Describe "$Global:DSCResourceName\Test-TargetResource" -Tag 'Test' {
            BeforeAll {
                $testTargetResourceParameters = @{
                    Name                                         = $mockResource.Name
                    ExternalUrl                                  = $mockResource.ExternalUrl
                    BackendServerUrl                             = $mockResource.BackendServerUrl
                    ADFSRelyingPartyName                         = $mockResource.ADFSRelyingPartyName
                    ADFSUserCertificateStore                     = $mockResource.ADFSUserCertificateStore
                    BackendServerAuthenticationSPN               = $mockResource.BackendServerAuthenticationSPN
                    BackendServerCertificateValidation           = $mockResource.BackendServerCertificateValidation
                    ClientCertificateAuthenticationBindingMode   = $mockResource.ClientCertificateAuthenticationBindingMode
                    ClientCertificatePreauthenticationThumbprint = $mockResource.ClientCertificatePreauthenticationThumbprint
                    DisableHttpOnlyCookieProtection              = $mockResource.DisableHttpOnlyCookieProtection
                    DisableTranslateUrlInRequestHeaders          = $mockResource.DisableTranslateUrlInRequestHeaders
                    DisableTranslateUrlInResponseHeaders         = $mockResource.DisableTranslateUrlInResponseHeaders
                    EnableHTTPRedirect                           = $mockResource.EnableHTTPRedirect
                    EnableSignOut                                = $mockResource.EnableSignOut
                    ExternalCertificateThumbprint                = $mockResource.ExternalCertificateThumbprint
                    ExternalPreauthentication                    = $mockResource.ExternalPreauthentication
                    InactiveTransactionsTimeoutSec               = $mockResource.InactiveTransactionsTimeoutSec
                    PersistentAccessCookieExpirationTimeSec      = $mockResource.PersistentAccessCookieExpirationTimeSec
                    UseOAuthAuthentication                       = $mockResource.UseOAuthAuthentication
                }

                $testTargetResourcePresentParameters = $testTargetResourceParameters.Clone()
                $testTargetResourcePresentParameters.Ensure = 'Present'

                $testTargetResourceAbsentParameters = $testTargetResourceParameters.Clone()
                $testTargetResourceAbsentParameters.Ensure = 'Absent'
            }

            Context 'When the Resource is Present' {
                BeforeAll {
                    Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourcePresentResult }
                }

                Context 'When the Resource should be Present' {
                    It 'Should not throw' {
                        { Test-TargetResource @testTargetResourcePresentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { `
                                $Name -eq $testTargetResourcePresentParameters.Name -and `
                                $ExternalUrl -eq $testTargetResourcePresentParameters.ExternalUrl -and `
                                $BackendServerUrl -eq $testTargetResourcePresentParameters.BackendServerUrl } `
                            -Exactly -Times 1
                    }

                    Context 'When all the resource properties are in the desired state' {
                        It 'Should return $true' {
                            Test-TargetResource @testTargetResourcePresentParameters | Should -Be $true
                        }
                    }

                    foreach ($property in $mockChangedResource.Keys)
                    {
                        Context "When the $property resource property is not in the desired state" {
                            BeforeAll {
                                $testTargetResourceNotInDesiredStateParameters = $testTargetResourcePresentParameters.Clone()
                                $testTargetResourceNotInDesiredStateParameters.$property = $mockChangedResource.$property
                            }

                            It 'Should return $false' {
                                Test-TargetResource @testTargetResourceNotInDesiredStateParameters | Should -Be $false
                            }
                        }
                    }
                }

                Context 'When the Resource should be Absent' {
                    It 'Should not throw' {
                        { Test-TargetResource @testTargetResourceAbsentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { `
                                $Name -eq $testTargetResourceAbsentParameters.Name -and `
                                $ExternalUrl -eq $testTargetResourceAbsentParameters.ExternalUrl -and `
                                $BackendServerUrl -eq $testTargetResourceAbsentParameters.BackendServerUrl } `
                            -Exactly -Times 1
                    }

                    It 'Should return $false' {
                        Test-TargetResource @testTargetResourceAbsentParameters | Should -Be $false
                    }
                }
            }

            Context 'When the Resource is Absent' {
                BeforeAll {
                    Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourceAbsentResult }
                }

                Context 'When the Resource should be Present' {
                    It 'Should not throw' {
                        { Test-TargetResource @testTargetResourcePresentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { `
                                $Name -eq $testTargetResourceAbsentParameters.Name -and `
                                $ExternalUrl -eq $testTargetResourceAbsentParameters.ExternalUrl -and `
                                $BackendServerUrl -eq $testTargetResourceAbsentParameters.BackendServerUrl } `
                            -Exactly -Times 1
                    }

                    It 'Should return $false' {
                        Test-TargetResource @testTargetResourcePresentParameters | Should -Be $false
                    }
                }

                Context 'When the Resource should be Absent' {
                    It 'Should not throw' {
                        { Test-TargetResource @testTargetResourceAbsentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { `
                                $Name -eq $testTargetResourceAbsentParameters.Name -and `
                                $ExternalUrl -eq $testTargetResourceAbsentParameters.ExternalUrl -and `
                                $BackendServerUrl -eq $testTargetResourceAbsentParameters.BackendServerUrl } `
                            -Exactly -Times 1
                    }

                    It 'Should return $true' {
                        Test-TargetResource @testTargetResourceAbsentParameters | Should -Be $true
                    }
                }
            }
        }
    }
}
finally
{
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
}
