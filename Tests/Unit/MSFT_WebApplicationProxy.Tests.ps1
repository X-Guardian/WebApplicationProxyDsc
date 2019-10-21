$Global:DSCModuleName = 'WebApplicationProxyDsc'
$Global:PSModuleName = 'WebApplicationProxy'
$Global:DscResourceFriendlyName = 'WebApplicationProxy'
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
            Get     = 'Get-WebApplicationProxyConfigurationStatus'
            Install = 'Install-WebApplicationProxy'
        }

        $mockResourceCommandError = @{
            Install = 'Error'
        }

        $mockUserName = 'CONTOSO\SvcAccount'
        $mockPassword = 'DummyPassword'

        $mockCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
            $mockUserName,
            (ConvertTo-SecureString -String $mockPassword -AsPlainText -Force)
        )

        $mockMSFTCredential = New-CimCredentialInstance -UserName $mockUserName

        $mockResource = @{
            FederationServiceName            = 'sts.contoso.com'
            CertificateThumbprint            = '0a1b2c3d0a1b2c3d0a1b2c3d0a1b2c3d0a1b2c3d'
            FederationServiceTrustCredential = $mockCredential
            ForwardProxy                     = 'proxy-01.corp.contoso.com:8080'
            HttpsPort                        = 443
            TlsClientPort                    = 49443
            Ensure                           = 'Present'
        }

        $mockAbsentResource = @{
            FederationServiceName            = $mockResource.FederationServiceName
            CertificateThumbprint            = $mockResource.CertificateThumbprint
            FederationServiceTrustCredential = $mockResource.FederationServiceTrustCredential
            ForwardProxy                     = $null
            HttpsPort                        = $null
            TlsClientPort                    = $null
            Ensure                           = 'Absent'
        }

        $mockGetTargetResourceResult = @{
            FederationServiceName            = $mockResource.FederationServiceName
            CertificateThumbprint            = $mockResource.CertificateThumbprint
            FederationServiceTrustCredential = $mockResource.FederationServiceName
            ForwardProxy                     = $mockResource.ForwardProxy
            HttpsPort                        = $mockResource.HttpsPort
            TlsClientPort                    = $mockResource.TlsClientPort
        }

        $mockGetTargetResourcePresentResult = $mockGetTargetResourceResult.Clone()
        $mockGetTargetResourcePresentResult.Ensure = 'Present'

        $mockGetTargetResourceAbsentResult = $mockGetTargetResourceResult.Clone()
        $mockGetTargetResourceAbsentResult.Ensure = 'Absent'

        Describe "$Global:DSCResourceName\Get-TargetResource" -Tag 'Get' {
            BeforeAll {
                $getTargetResourceParameters = @{
                    FederationServiceName            = $mockResource.FederationServiceName
                    CertificateThumbprint            = $mockResource.CertificateThumbprint
                    FederationServiceTrustCredential = $mockResource.FederationServiceTrustCredential
                }

                $mockGetResourceCommandResult = @{
                    FederationServiceName            = $mockResource.FederationServiceName
                    CertificateThumbprint            = $mockResource.CertificateThumbprint
                    FederationServiceTrustCredential = $mockResource.FederationServiceTrustCredential
                }

                $mockGetWebApplicationProxySslCertificateResult = @{
                    CertificateHash = $mockResource.CertificateThumbprint
                }

                $mockGetCimInstanceProxyServiceResult = @{
                    HostName                = $mockResource.FederationServiceName
                    ForwardHttpProxyAddress = $mockResource.ForwardProxy
                    HostHttpsPort           = $mockResource.HttpsPort
                    TlsClientPort           = $mockResource.TlsClientPort
                }

                Mock -CommandName Assert-Module
                Mock -CommandName $ResourceCommand.Get -MockWith { $mockGetResourceCommandResult }
                Mock -CommandName Get-CimInstance -ParameterFilter {
                    $Namespace -eq 'root/ADFS' -and $ClassName -eq 'ProxyService' } `
                    -MockWith { $mockGetCimInstanceProxyServiceResult }
                Mock -CommandName Get-WebApplicationProxySslCertificate `
                    -MockWith { $mockGetWebApplicationProxySslCertificateResult }
            }

            Context "When the $($Global:DscResourceFriendlyName) Resource is Present" {
                BeforeAll {
                    Mock -CommandName $ResourceCommand.Get -MockWith { 'Configured' }

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
                    Assert-MockCalled -CommandName $ResourceCommand.Get -Exactly -Times 1
                    Assert-MockCalled -CommandName Get-CimInstance `
                        -ParameterFilter { $Namespace -eq 'root/ADFS' -and $ClassName -eq 'ProxyService' } `
                        -Exactly -Times 1
                }

                Context "When Get-CimInstance throws an exception" {
                    BeforeAll {
                        Mock -CommandName Get-CimInstance -ParameterFilter {
                            $Namespace -eq 'root/ADFS' -and $ClassName -eq 'ProxyService' } `
                            -MockWith { throw 'Error' }
                    }

                    It 'Should throw the correct exception' {
                        { Get-TargetResource @getTargetResourceParameters } | Should -Throw (
                            $script:localizedData.GettingWapProxyServiceError -f
                            $mockResource.FederationServiceName)
                    }
                }

                Context "When Get-WebApplicationProxySslCertificate throws an exception" {
                    BeforeAll {
                        Mock Get-WebApplicationProxySslCertificate -MockWith { throw 'Error' }
                    }

                    It 'Should throw the correct exception' {
                        { Get-TargetResource @getTargetResourceParameters } | Should -Throw (
                            $script:localizedData.GettingWapSslCertificateError -f
                            $mockResource.FederationServiceName)
                    }
                }

                Context "When Get-WebApplicationProxySslCertificate returns no results" {
                    BeforeAll {
                        Mock Get-WebApplicationProxySslCertificate
                    }

                    It 'Should throw the correct exception' {
                        { Get-TargetResource @getTargetResourceParameters } | Should -Throw (
                            $script:localizedData.GettingWapSslCertificateError -f
                            $mockResource.FederationServiceName)
                    }
                }
            }

            Context "When the $($Global:DscResourceFriendlyName) Resource is Absent" {
                BeforeAll {
                    Mock -CommandName $ResourceCommand.Get -MockWith { 'NotConfigured' }

                    $result = Get-TargetResource @getTargetResourceParameters
                }

                foreach ($property in $mockResource.Keys)
                {
                    It "Should return the correct $property property" {
                        $result.$property | Should -Be $mockAbsentResource.$property
                    }
                }

                It 'Should call the expected mocks' {
                    Assert-MockCalled -CommandName Assert-Module `
                        -ParameterFilter { $ModuleName -eq $Global:PSModuleName } `
                        -Exactly -Times 1
                    Assert-MockCalled -CommandName $ResourceCommand.Get -Exactly -Times 1
                }
            }
        }

        Describe "$Global:DSCResourceName\Set-TargetResource" -Tag 'Set' {
            BeforeAll {
                $setTargetResourceParameters = @{
                    FederationServiceName            = $mockResource.FederationServiceName
                    CertificateThumbprint            = $mockResource.CertificateThumbprint
                    FederationServiceTrustCredential = $mockResource.FederationServiceTrustCredential
                }
                $mockInstallResourceSuccessResult = @{
                    Message = 'The configuration completed successfully.'
                    Context = 'DeploymentSucceeded'
                    Status  = 'Success'
                }

                $mockInstallResourceErrorResult = @{
                    Message = 'The configuration did not complete successfully.'
                    Context = 'DeploymentTask'
                    Status  = 'Error'
                }

                Mock -CommandName $ResourceCommand.Install -MockWith { $mockInstallResourceSuccessResult }
            }

            Context "When the $($Global:DscResourceFriendlyName) Resource is not installed" {
                BeforeAll {
                    $mockGetTargetResourceAbsentResult = @{
                        Ensure = 'Absent'
                    }

                    Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourceAbsentResult }
                }

                It 'Should not throw' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should call the expected mocks' {
                    Assert-MockCalled -CommandName $ResourceCommand.Install `
                        -ParameterFilter { $FederationServiceName -eq $setTargetResourceParameters.FederationServiceName } `
                        -Exactly -Times 1
                }

                Context "When $ResourceCommand.Install throws an exception" {
                    BeforeAll {
                        Mock $ResourceCommand.Install -MockWith { throw $mockResourceCommandError.Install }
                    }

                    It 'Should throw the correct error' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Throw (
                            $script:localizedData.InstallationError -f $setTargetResourceParameters.FederationServiceName)
                    }
                }

                Context "When $($ResourceCommand.Install) returns a result with a status of 'Error'" {
                    BeforeAll {
                        Mock $ResourceCommand.Install -MockWith { $mockInstallResourceErrorResult }
                    }

                    It 'Should throw the correct error' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Throw (
                            $mockInstallResourceErrorResult.Message)
                    }
                }
            }

            Context "When the $($Global:DscResourceFriendlyName) Resource is installed" {
                BeforeAll {
                    Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourcePresentResult }
                }

                It 'Should not throw' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw
                }
            }
        }

        Describe "$Global:DSCResourceName\Test-TargetResource" -Tag 'Test' {
            BeforeAll {
                $testTargetResourceParameters = @{
                    FederationServiceName            = $mockResource.FederationServiceName
                    CertificateThumbprint            = $mockResource.CertificateThumbprint
                    FederationServiceTrustCredential = $mockResource.FederationServiceTrustCredential
                }
            }

            Context "When the $($Global:DscResourceFriendlyName) Resource is installed" {
                BeforeAll {
                    Mock Get-TargetResource -MockWith { $mockGetTargetResourcePresentResult }
                }

                It 'Should return $true' {
                    Test-TargetResource @testTargetResourceParameters | Should -BeTrue
                }

                It 'Should call the expected mocks' {
                    Assert-MockCalled -CommandName Get-TargetResource `
                        -ParameterFilter { `
                            $FederationServiceName -eq $testTargetResourceParameters.FederationServiceName } `
                        -Exactly -Times 1

                }
            }

            Context "When the $($Global:DscResourceFriendlyName) Resource is not installed" {
                BeforeAll {
                    Mock Get-TargetResource -MockWith { $mockGetTargetResourceAbsentResult }
                }

                It 'Should return $false' {
                    Test-TargetResource @testTargetResourceParameters | Should -BeFalse
                }

                It 'Should call the expected mocks' {
                    Assert-MockCalled -CommandName Get-TargetResource `
                        -ParameterFilter { `
                            $FederationServiceName -eq $testTargetResourceParameters.FederationServiceName } `
                        -Exactly -Times 1
                }
            }
        }
    }
}
finally
{
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
}
