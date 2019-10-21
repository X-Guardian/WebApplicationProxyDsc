$Global:DSCModuleName = 'WebApplicationProxyDsc'
$Global:PSModuleName = 'WebApplicationProxy'
$Global:DscResourceFriendlyName = 'WebApplicationProxyConfiguration'
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
            Get = 'Get-WebApplicationProxyConfiguration'
            Set = 'Set-WebApplicationProxyConfiguration'
        }

        $mockResource = @{
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

        $mockChangedResource = @{
            ADFSSignOutUrl                         = 'https://sts.farbrikam.com/adfs/ls/?wa=wsignout1.0'
            ADFSTokenAcceptanceDurationSec         = 240
            ADFSTokenSigningCertificatePublicKey   = '0a1b2c3d0a1b2c3d0a1b2c3d0a1b2c3d0a1b2c3e'
            ADFSUrl                                = 'https://sts.fabrikam.com/adfs/ls'
            ADFSWebApplicationProxyRelyingPartyUri = 'urn:AppProxy2:com'
            ConfigurationChangesPollingIntervalSec = 60
            ConnectedServersName                   = 'wap01.fabrikam.com'
            OAuthAuthenticationURL                 = 'https://sts.fabrikam.com/adfs/oauth2/authorize'
            UserIdleTimeoutAction                  = 'Reauthenticate'
            UserIdleTimeoutSec                     = 600
        }

        $mockGetTargetResourceResult = @{
            FederationServiceName                  = $mockResource.FederationServiceName
            ADFSSignOutURL                         = $mockResource.ADFSSignOutUrl
            ADFSTokenAcceptanceDurationSec         = $mockResource.ADFSTokenAcceptanceDurationSec
            ADFSTokenSigningCertificatePublicKey   = $mockResource.ADFSTokenSigningCertificatePublicKey
            ADFSUrl                                = $mockResource.ADFSUrl
            ADFSWebApplicationProxyRelyingPartyUri = $mockResource.ADFSWebApplicationProxyRelyingPartyUri
            ConfigurationChangesPollingIntervalSec = $mockResource.ConfigurationChangesPollingIntervalSec
            ConnectedServersName                   = $mockResource.ConnectedServersName
            OAuthAuthenticationURL                 = $mockResource.OAuthAuthenticationURL
            UserIdleTimeoutAction                  = $mockResource.UserIdleTimeoutAction
            UserIdleTimeoutSec                     = $mockResource.UserIdleTimeoutSec
        }

        Describe "$Global:DSCResourceName\Get-TargetResource" -Tag 'Get' {
            BeforeAll {
                $getTargetResourceParameters = @{
                    FederationServiceName = $mockResource.FederationServiceName
                }

                $mockGetResourceCommandResult = @{
                    FederationServiceName                  = $mockResource.FederationServiceName
                    ADFSSignOutURL                         = $mockResource.ADFSSignOutURL
                    ADFSTokenAcceptanceDurationSec         = $mockResource.ADFSTokenAcceptanceDurationSec
                    ADFSTokenSigningCertificatePublicKey   = $mockResource.ADFSTokenSigningCertificatePublicKey
                    ADFSUrl                                = $mockResource.ADFSUrl
                    ADFSWebApplicationProxyRelyingPartyUri = $mockResource.ADFSWebApplicationProxyRelyingPartyUri
                    ConfigurationChangesPollingIntervalSec = $mockResource.ConfigurationChangesPollingIntervalSec
                    ConnectedServersName                   = $mockResource.ConnectedServersName
                    OAuthAuthenticationURL                 = $mockResource.OAuthAuthenticationURL
                    UserIdleTimeoutAction                  = $mockResource.UserIdleTimeoutAction
                    UserIdleTimeoutSec                     = $mockResource.UserIdleTimeoutSec
                }

                Mock -CommandName Assert-Module
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
                Assert-MockCalled -CommandName $ResourceCommand.Get -Exactly -Times 1
            }

            Context "When $($ResourceCommand.Get) throws an exception" {
                BeforeAll {
                    Mock -CommandName $ResourceCommand.Get -MockWith { Throw 'Error' }
                }

                It 'Should throw the correct exception' {
                    { Get-TargetResource @getTargetResourceParameters } | Should -Throw (
                        $script:localizedData.GettingResourceError -f `
                            $getTargetResourceParameters.FederationServiceName )
                }
            }
        }

        Describe "$Global:DSCResourceName\Set-TargetResource" -Tag 'Set' {
            BeforeAll {
                $setTargetResourceParameters = @{
                    FederationServiceName                  = $mockResource.FederationServiceName
                    ADFSSignOutURL                         = $mockResource.ADFSSignOutURL
                    ADFSTokenAcceptanceDurationSec         = $mockResource.ADFSTokenAcceptanceDurationSec
                    ADFSTokenSigningCertificatePublicKey   = $mockResource.ADFSTokenSigningCertificatePublicKey
                    ADFSUrl                                = $mockResource.ADFSUrl
                    ADFSWebApplicationProxyRelyingPartyUri = $mockResource.ADFSWebApplicationProxyRelyingPartyUri
                    ConfigurationChangesPollingIntervalSec = $mockResource.ConfigurationChangesPollingIntervalSec
                    ConnectedServersName                   = $mockResource.ConnectedServersName
                    OAuthAuthenticationURL                 = $mockResource.OAuthAuthenticationURL
                    UserIdleTimeoutAction                  = $mockResource.UserIdleTimeoutAction
                    UserIdleTimeoutSec                     = $mockResource.UserIdleTimeoutSec
                }

                Mock -CommandName $ResourceCommand.Set
                Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourceResult }
            }

            foreach ($property in $mockChangedResource.Keys)
            {
                Context "When $property has changed" {
                    BeforeAll {
                        $setTargetResourceParametersChangedProperty = $setTargetResourceParameters.Clone()
                        $setTargetResourceParametersChangedProperty.$property = $mockChangedResource.$property
                    }

                    It 'Should not throw' {
                        { Set-TargetResource @setTargetResourceParametersChangedProperty } | Should -Not -Throw
                    }

                    It 'Should call the correct mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { $FederationServiceName -eq `
                                $setTargetResourceParametersChangedProperty.FederationServiceName } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Set -Exactly -Times 1
                    }
                }
            }

            Context "When $($ResourceCommand.Set) throws an exception" {
                BeforeAll {
                    Mock -CommandName $ResourceCommand.Set -MockWith { Throw 'Error' }
                }

                It 'Should throw the correct exception' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Throw (
                        $script:localizedData.SettingResourceError -f `
                            $setTargetResourceParameters.FederationServiceName )
                }
            }
        }

        Describe "$Global:DSCResourceName\Test-TargetResource" -Tag 'Test' {
            BeforeAll {
                $testTargetResourceParameters = @{
                    FederationServiceName                  = $mockResource.FederationServiceName
                    ADFSSignOutURL                         = $mockResource.ADFSSignOutURL
                    ADFSTokenAcceptanceDurationSec         = $mockResource.ADFSTokenAcceptanceDurationSec
                    ADFSTokenSigningCertificatePublicKey   = $mockResource.ADFSTokenSigningCertificatePublicKey
                    ADFSUrl                                = $mockResource.ADFSUrl
                    ADFSWebApplicationProxyRelyingPartyUri = $mockResource.ADFSWebApplicationProxyRelyingPartyUri
                    ConfigurationChangesPollingIntervalSec = $mockResource.ConfigurationChangesPollingIntervalSec
                    ConnectedServersName                   = $mockResource.ConnectedServersName
                    OAuthAuthenticationURL                 = $mockResource.OAuthAuthenticationURL
                    UserIdleTimeoutAction                  = $mockResource.UserIdleTimeoutAction
                    UserIdleTimeoutSec                     = $mockResource.UserIdleTimeoutSec
                }

                Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourceResult }
            }

            It 'Should not throw' {
                { Test-TargetResource @testTargetResourceParameters } | Should -Not -Throw
            }

            It 'Should call the expected mocks' {
                Assert-MockCalled -CommandName Get-TargetResource `
                    -ParameterFilter { $FederationServiceName -eq `
                        $testTargetResourceParameters.FederationServiceName } `
                    -Exactly -Times 1
            }

            Context 'When all the resource properties are in the desired state' {
                It 'Should return $true' {
                    Test-TargetResource @testTargetResourceParameters | Should -Be $true
                }
            }

            foreach ($property in $mockChangedResource.Keys)
            {
                Context "When the $property resource property is not in the desired state" {
                    BeforeAll {
                        $testTargetResourceNotInDesiredStateParameters = $testTargetResourceParameters.Clone()
                        $testTargetResourceNotInDesiredStateParameters.$property = $mockChangedResource.$property
                    }

                    It 'Should return $false' {
                        Test-TargetResource @testTargetResourceNotInDesiredStateParameters | Should -Be $false
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
