$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules\WebApplicationProxyDsc.Common'

Import-Module -Name (Join-Path -Path $script:modulesFolderPath -ChildPath 'WebApplicationProxyDsc.Common.psm1') -Force

InModuleScope 'WebApplicationProxyDsc.Common' {
    Describe 'WebApplicationProxyDsc.Common\Get-LocalizedData' {
        BeforeAll {
            $mockImportLocalizedData = {
                $BaseDirectory | Should -Be $mockExpectedLanguagePath
            }

            Mock -CommandName Import-LocalizedData -MockWith $mockImportLocalizedData -Verifiable
        }

        Context 'When loading localized data for Swedish' {

            Context 'When the Swedish language path exists' {
                BeforeAll {
                    $mockExpectedLanguagePath = 'sv-SE'
                    $mockTestPathReturnValue = $true

                    Mock -CommandName Test-Path -MockWith { $mockTestPathReturnValue } -Verifiable
                    Mock -CommandName Join-Path -MockWith { $mockExpectedLanguagePath } -Verifiable
                }

                It 'Should not throw an error' {
                    { Get-LocalizedData -ResourceName 'DummyResource' } | Should -Not -Throw
                }

                It 'Should call the expected mocks' {
                    Assert-MockCalled -CommandName Join-Path -Exactly -Times 3
                    Assert-MockCalled -CommandName Test-Path -Exactly -Times 1
                    Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1
                }
            }

            Context ' When the Swedish language path does not exist' {
                BeforeAll {
                    $mockExpectedLanguagePath = 'en-US'
                    $mockTestPathReturnValue = $false

                    Mock -CommandName Test-Path -MockWith { $mockTestPathReturnValue } -Verifiable
                    Mock -CommandName Join-Path -MockWith { $ChildPath } -Verifiable
                }

                It 'Should not throw an error' {
                    { Get-LocalizedData -ResourceName 'DummyResource' } | Should -Not -Throw
                }

                It 'Should call the expected mocks' {
                    Assert-MockCalled -CommandName Join-Path -Exactly -Times 4
                    Assert-MockCalled -CommandName Test-Path -Exactly -Times 1
                    Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1
                }
            }

            Context 'When $ScriptRoot is set to a path' {

                Context 'When the Swedish language path exists' {
                    BeforeAll {
                        $mockExpectedLanguagePath = 'sv-SE'
                        $mockTestPathReturnValue = $true

                        Mock -CommandName Test-Path -MockWith { $mockTestPathReturnValue } -Verifiable
                        Mock -CommandName Join-Path -MockWith { $mockExpectedLanguagePath } -Verifiable
                    }

                    It 'Should not throw an error' {
                        { Get-LocalizedData -ResourceName 'DummyResource' -ScriptRoot '.' } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Join-Path -Exactly -Times 1
                        Assert-MockCalled -CommandName Test-Path -Exactly -Times 1
                        Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1
                    }
                }

                Context 'When the Swedish language path does not exist' {
                    BeforeAll {
                        $mockExpectedLanguagePath = 'en-US'
                        $mockTestPathReturnValue = $false

                        Mock -CommandName Test-Path -MockWith { $mockTestPathReturnValue } -Verifiable
                        Mock -CommandName Join-Path -MockWith { $ChildPath } -Verifiable
                    }

                    It 'Should not throw an error' {
                        { Get-LocalizedData -ResourceName 'DummyResource' -ScriptRoot '.' } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Join-Path -Exactly -Times 2
                        Assert-MockCalled -CommandName Test-Path -Exactly -Times 1
                        Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1
                    }
                }
            }
        }

        Context 'When loading localized data for US English' {
            BeforeAll {
                $mockExpectedLanguagePath = 'en-US'
                $mockTestPathReturnValue = $true

                Mock -CommandName Test-Path -MockWith { $mockTestPathReturnValue } -Verifiable
                Mock -CommandName Join-Path -MockWith { $mockExpectedLanguagePath } -Verifiable
            }

            It 'Should not throw an error' {
                { Get-LocalizedData -ResourceName 'DummyResource' } | Should -Not -Throw
            }

            It 'Should call the expected mocks' {
                Assert-MockCalled -CommandName Join-Path -Exactly -Times 3
                Assert-MockCalled -CommandName Test-Path -Exactly -Times 1
                Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1
            }
        }

        Assert-VerifiableMock
    }

    Describe 'WebApplicationProxyDsc.Common\New-InvalidArgumentException' {
        Context 'When calling with both the Message and ArgumentName parameter' {
            BeforeAll {
                $mockErrorMessage = 'Mocked error'
                $mockArgumentName = 'MockArgument'
            }

            It 'Should throw the correct error' {
                { New-InvalidArgumentException -Message $mockErrorMessage -ArgumentName $mockArgumentName } |
                    Should -Throw ('Parameter name: {0}' -f $mockArgumentName)
            }
        }
    }

    Describe 'WebApplicationProxyDsc.Common\New-InvalidOperationException' {
        Context 'When calling with Message parameter only' {
            BeforeAll {
                $mockErrorMessage = 'Mocked error'
            }

            It 'Should throw the correct error' {
                { New-InvalidOperationException -Message $mockErrorMessage } | Should -Throw $mockErrorMessage
            }
        }

        Context 'When calling with both the Message and ErrorRecord parameter' {
            BeforeAll {
                $mockErrorMessage = 'Mocked error'
                $mockExceptionErrorMessage = 'Mocked exception error message'

                $mockException = New-Object -TypeName 'System.Exception' -ArgumentList $mockExceptionErrorMessage
                $mockErrorRecord = New-Object -TypeName 'System.Management.Automation.ErrorRecord' `
                    -ArgumentList @($mockException, $null, 'InvalidResult', $null)
            }

            It 'Should throw the correct error' {
                { New-InvalidOperationException -Message $mockErrorMessage -ErrorRecord $mockErrorRecord } |
                    Should -Throw ('System.InvalidOperationException: {0} ---> System.Exception: {1}' -f
                        $mockErrorMessage, $mockExceptionErrorMessage)
            }
        }
    }

    Describe 'WebApplicationProxyDsc.Common\New-ObjectNotFoundException' {
        Context 'When calling with Message parameter only' {
            BeforeAll {
                $mockErrorMessage = 'Mocked error'
            }

            It 'Should throw the correct error' {
                { New-ObjectNotFoundException -Message $mockErrorMessage } | Should -Throw $mockErrorMessage
            }
        }

        Context 'When calling with both the Message and ErrorRecord parameter' {
            BeforeAll {
                $mockErrorMessage = 'Mocked error'
                $mockExceptionErrorMessage = 'Mocked exception error message'

                $mockException = New-Object -TypeName 'System.Exception' -ArgumentList $mockExceptionErrorMessage
                $mockErrorRecord = New-Object -TypeName 'System.Management.Automation.ErrorRecord' `
                    -ArgumentList @($mockException, $null, 'InvalidResult', $null)
            }

            It 'Should throw the correct error' {
                { New-ObjectNotFoundException -Message $mockErrorMessage -ErrorRecord $mockErrorRecord } |
                    Should -Throw ('System.Exception: {0} ---> System.Exception: {1}' -f
                        $mockErrorMessage, $mockExceptionErrorMessage)
            }
        }
    }

    Describe 'WebApplicationProxyDsc.Common\New-InvalidResultException' {
        Context 'When calling with Message parameter only' {
            BeforeAll {
                $mockErrorMessage = 'Mocked error'
            }

            It 'Should throw the correct error' {
                { New-InvalidResultException -Message $mockErrorMessage } | Should -Throw $mockErrorMessage
            }
        }

        Context 'When calling with both the Message and ErrorRecord parameter' {
            BeforeAll {
                $mockErrorMessage = 'Mocked error'
                $mockExceptionErrorMessage = 'Mocked exception error message'

                $mockException = New-Object -TypeName 'System.Exception' -ArgumentList $mockExceptionErrorMessage
                $mockErrorRecord = New-Object -TypeName 'System.Management.Automation.ErrorRecord' `
                    -ArgumentList @($mockException, $null, 'InvalidResult', $null)
            }

            It 'Should throw the correct error' {
                { New-InvalidResultException -Message $mockErrorMessage -ErrorRecord $mockErrorRecord } |
                    Should -Throw ('System.Exception: {0} ---> System.Exception: {1}' -f
                        $mockErrorMessage, $mockExceptionErrorMessage)
            }
        }
    }

    Describe 'WebApplicationProxyDsc.Common\New-NotImplementedException' {
        Context 'When calling with Message parameter only' {
            BeforeAll {
                $mockErrorMessage = 'Mocked error'
            }

            It 'Should throw the correct error' {
                { New-NotImplementedException -Message $mockErrorMessage } | Should -Throw $mockErrorMessage
            }
        }

        Context 'When calling with both the Message and ErrorRecord parameter' {
            BeforeAll {
                $mockErrorMessage = 'Mocked error'
                $mockExceptionErrorMessage = 'Mocked exception error message'

                $mockException = New-Object -TypeName 'System.Exception' -ArgumentList $mockExceptionErrorMessage
                $mockErrorRecord = New-Object -TypeName 'System.Management.Automation.ErrorRecord' `
                    -ArgumentList @($mockException, $null, 'NotImplemented', $null)
            }

            It 'Should throw the correct error' {
                { New-NotImplementedException -Message $mockErrorMessage -ErrorRecord $mockErrorRecord } |
                    Should -Throw ('System.NotImplementedException: {0} ---> System.Exception: {1}' -f
                        $mockErrorMessage, $mockExceptionErrorMessage)
            }
        }
    }

    Describe 'WebApplicationProxyDsc.Common\Compare-ResourcePropertyState' {
        Context 'When one property is in desired state' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 1
                $compareTargetResourceStateResult.ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult.Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult.Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult.InDesiredState | Should -BeTrue
            }
        }

        Context 'When two properties are in desired state' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                    Location     = 'Sweden'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Location     = 'Sweden'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 2
                $compareTargetResourceStateResult[0].ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult[0].Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].InDesiredState | Should -BeTrue
                $compareTargetResourceStateResult[1].ParameterName | Should -Be 'Location'
                $compareTargetResourceStateResult[1].Expected | Should -Be 'Sweden'
                $compareTargetResourceStateResult[1].Actual | Should -Be 'Sweden'
                $compareTargetResourceStateResult[1].InDesiredState | Should -BeTrue
            }
        }

        Context 'When passing just one property and that property is not in desired state' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                }

                $mockDesiredValues = @{
                    ComputerName = 'APP01'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 1
                $compareTargetResourceStateResult.ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult.Expected | Should -Be 'APP01'
                $compareTargetResourceStateResult.Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult.InDesiredState | Should -BeFalse
            }
        }

        Context 'When passing two properties and one property is not in desired state' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                    Location     = 'Sweden'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Location     = 'Europe'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 2
                $compareTargetResourceStateResult[0].ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult[0].Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].InDesiredState | Should -BeTrue
                $compareTargetResourceStateResult[1].ParameterName | Should -Be 'Location'
                $compareTargetResourceStateResult[1].Expected | Should -Be 'Europe'
                $compareTargetResourceStateResult[1].Actual | Should -Be 'Sweden'
                $compareTargetResourceStateResult[1].InDesiredState | Should -BeFalse
            }
        }

        Context 'When passing a common parameter set to desired value' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Verbose      = $true
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 1
                $compareTargetResourceStateResult.ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult.Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult.Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult.InDesiredState | Should -BeTrue
            }
        }

        Context 'When using parameter Properties to compare desired values' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                    Location     = 'Sweden'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Location     = 'Europe'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                    Properties    = @(
                        'ComputerName'
                    )
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 1
                $compareTargetResourceStateResult.ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult.Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult.Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult.InDesiredState | Should -BeTrue
            }
        }

        Context 'When using parameter Properties and IgnoreProperties to compare desired values' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                    Location     = 'Sweden'
                    Ensure       = 'Present'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Location     = 'Europe'
                    Ensure       = 'Absent'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues    = $mockCurrentValues
                    DesiredValues    = $mockDesiredValues
                    IgnoreProperties = @(
                        'Ensure'
                    )
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 2
                $compareTargetResourceStateResult[0].ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult[0].Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].InDesiredState | Should -BeTrue
                $compareTargetResourceStateResult[1].ParameterName | Should -Be 'Location'
                $compareTargetResourceStateResult[1].Expected | Should -Be 'Europe'
                $compareTargetResourceStateResult[1].Actual | Should -Be 'Sweden'
                $compareTargetResourceStateResult[1].InDesiredState | Should -BeFalse
            }
        }

        Context 'When using parameter Properties and IgnoreProperties to compare desired values' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                    Location     = 'Sweden'
                    Ensure       = 'Present'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Location     = 'Europe'
                    Ensure       = 'Absent'
                }
            }

            It 'Should return an empty array' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues    = $mockCurrentValues
                    DesiredValues    = $mockDesiredValues
                    Properties       = @(
                        'ComputerName'
                    )
                    IgnoreProperties = @(
                        'ComputerName'
                    )
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -BeNullOrEmpty
            }
        }
    }

    Describe 'DscResource.Common\Test-DscPropertyState' -Tag 'TestDscPropertyState' {
        Context 'When comparing strings' {

            Context 'When the strings match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.String] 'Test'
                        DesiredValue = [System.String] 'Test'
                    }
                }

                It 'Should return true' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $true
                }
            }

            Context 'When the strings do not match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.String] 'something'
                        DesiredValue = [System.String] 'test'
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the string current value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = $null
                        DesiredValue = [System.String] 'Something'
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the string desired value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.String] 'Something'
                        DesiredValue = $null
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }
        }

        Context 'When comparing Int16' {

            Context 'When the integers match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.Int16] 1
                        DesiredValue = [System.Int16] 1
                    }
                }

                It 'Should return true' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $true
                }
            }

            Context 'When the integers do not match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.Int16] 1
                        DesiredValue = [System.Int16] 2
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the integers current value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = $null
                        DesiredValue = [System.Int16] 1
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the integers desired value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.Int16] 1
                        DesiredValue = $null
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }
        }

        Context 'When comparing UInt16' {
            Context 'When the integers match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.UInt16] 1
                        DesiredValue = [System.UInt16] 1
                    }
                }

                It 'Should return true' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $true
                }
            }

            Context 'When the integers do not match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.UInt16] 1
                        DesiredValue = [System.UInt16] 2
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the integers current value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = $null
                        DesiredValue = [System.UInt16] 1
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the integers desired value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.UInt16] 1
                        DesiredValue = $null
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }
        }

        Context 'When comparing Int32' {
            Context 'When the integers match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.Int32] 1
                        DesiredValue = [System.Int32] 1
                    }
                }

                It 'Should return true' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $true
                }
            }

            Context 'When the integers do not match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.Int32] 1
                        DesiredValue = [System.Int32] 2
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the integers current value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = $null
                        DesiredValue = [System.Int32] 1
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the integers desired value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.Int32] 1
                        DesiredValue = $null
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }
        }

        Context 'When comparing UInt32' {
            Context 'When the integers match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.UInt32] 1
                        DesiredValue = [System.UInt32] 1
                    }
                }

                It 'Should return true' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $true
                }
            }

            Context 'When the integers do not match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.UInt32] 1
                        DesiredValue = [System.UInt32] 2
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the integers current value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = $null
                        DesiredValue = [System.UInt32] 1
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the integers desired value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.UInt32] 1
                        DesiredValue = $null
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }
        }

        Context 'When comparing Single' {
            Context 'When the singles match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.Single] 1.5
                        DesiredValue = [System.Single] 1.5
                    }
                }

                It 'Should return true' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $true
                }
            }

            Context 'When the singles do not match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.Single] 1.5
                        DesiredValue = [System.Single] 2.5
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the single current value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = $null
                        DesiredValue = [System.Single] 1.5
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When the single desired value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.Single] 1.5
                        DesiredValue = $null
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }
        }

        Context 'When comparing booleans' {
            Context 'When the booleans match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.Boolean] $true
                        DesiredValue = [System.Boolean] $true
                    }
                }

                It 'Should return true' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $true
                }
            }

            Context 'When the booleans do not match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = [System.Boolean] $true
                        DesiredValue = [System.Boolean] $false
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }

            Context 'When a boolean value is missing' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = $null
                        DesiredValue = [System.Boolean] $true
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -Be $false
                }
            }
        }

        Context 'When comparing arrays' {
            Context 'When the arrays match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = @('1', '2')
                        DesiredValue = @('1', '2')
                    }
                }

                It 'Should return true' {
                    Test-DscPropertyState -Values $mockValues | Should -BeTrue
                }
            }

            Context 'When the arrays do not match' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = @('CurrentValueA', 'CurrentValueB')
                        DesiredValue = @('DesiredValue1', 'DesiredValue2')
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -BeFalse
                }
            }

            Context 'When the current value is $null' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = $null
                        DesiredValue = @('1', '2')
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -BeFalse
                }
            }

            Context 'When the desired value is $null' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = @('1', '2')
                        DesiredValue = $null
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -BeFalse
                }
            }

            Context 'When the current value is an empty array' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = @()
                        DesiredValue = @('1', '2')
                    }

                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -BeFalse
                }
            }

            Context 'when the desired value is an empty array' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = @('1', '2')
                        DesiredValue = @()
                    }
                }

                It 'Should return false' {
                    Test-DscPropertyState -Values $mockValues | Should -BeFalse
                }
            }

            Context 'when both values are $null' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = $null
                        DesiredValue = $null
                    }
                }

                It 'Should return true ' {
                    Test-DscPropertyState -Values $mockValues -Verbose | Should -BeTrue
                }
            }

            Context 'When both values are an empty array' {
                BeforeAll {
                    $mockValues = @{
                        CurrentValue = @()
                        DesiredValue = @()
                    }
                }

                It 'Should return true' {
                    Test-DscPropertyState -Values $mockValues -Verbose | Should -BeTrue
                }
            }
        }

        Context -Name 'When passing unsupported types for DesiredValue' {
            BeforeAll {
                Mock -CommandName Write-Warning -Verifiable
                $mockUnknownType = 'MockUnknowntype'

                # This is a dummy type to test with a type that could never be a correct one.
                class MockUnknownType
                {
                    [ValidateNotNullOrEmpty()]
                    [System.String]
                    $Property1

                    [ValidateNotNullOrEmpty()]
                    [System.String]
                    $Property2

                    MockUnknownType()
                    {
                    }
                }

                $mockValues = @{
                    CurrentValue = New-Object -TypeName $mockUnknownType
                    DesiredValue = New-Object -TypeName $mockUnknownType
                }
            }

            It 'Should return false' {
                Test-DscPropertyState -Values $mockValues | Should -Be $false
            }

            It 'Should write the correct warning' {
                Assert-MockCalled -CommandName Write-Warning `
                    -ParameterFilter { $Message -eq ($script:localizedData.UnableToCompareType -f $mockUnknownType) } `
                    -Exactly -Times 1
            }
        }

        Assert-VerifiableMock
    }

    Describe 'WebApplicationProxyDsc.Common\New-CimCredentialInstance' {
        Context 'When creating a new MSFT_Credential CIM instance credential object' {
            BeforeAll {
                $mockAdministratorUser = 'admin@contoso.com'
                $mockAdministratorPassword = 'P@ssw0rd-12P@ssw0rd-12'
                $mockAdministratorCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' `
                    -ArgumentList @(
                    $mockAdministratorUser,
                    ($mockAdministratorPassword | ConvertTo-SecureString -AsPlainText -Force)
                )
            }

            Context 'When the Credential parameter is specified' {
                It 'Should return the correct values' {
                    $newCimCredentialInstanceResult = New-CimCredentialInstance -Credential $mockAdministratorCredential
                    $newCimCredentialInstanceResult | Should -BeOfType 'Microsoft.Management.Infrastructure.CimInstance'
                    $newCimCredentialInstanceResult.CimClass.CimClassName | Should -Be 'MSFT_Credential'
                    $newCimCredentialInstanceResult.UserName | Should -Be $mockAdministratorUser
                    $newCimCredentialInstanceResult.Password | Should -BeNullOrEmpty
                }
            }

            Context 'When the UserName parameter is specified' {
                It 'Should return the correct values' {
                    $newCimCredentialInstanceResult = New-CimCredentialInstance -UserName $mockAdministratorUser
                    $newCimCredentialInstanceResult | Should -BeOfType 'Microsoft.Management.Infrastructure.CimInstance'
                    $newCimCredentialInstanceResult.CimClass.CimClassName | Should -Be 'MSFT_Credential'
                    $newCimCredentialInstanceResult.UserName | Should -Be $mockAdministratorUser
                    $newCimCredentialInstanceResult.Password | Should -BeNullOrEmpty
                }
            }
        }
    }

    Describe 'WebApplicationProxyDsc.Common\Assert-Module' {
        BeforeAll {
            $testModuleName = 'TestModule'
        }

        Context 'When module is not installed' {
            BeforeAll {
                Mock -CommandName Get-Module
            }

            It 'Should throw the correct error' {
                { Assert-Module -ModuleName $testModuleName } |
                    Should -Throw ($script:localizedData.ModuleNotFoundError -f $testModuleName)
            }
        }

        Context 'When module is available' {
            BeforeAll {
                Mock -CommandName Import-Module
                Mock -CommandName Get-Module -MockWith {
                    return @{
                        Name = $testModuleName
                    }
                }
            }

            Context 'When module should not be imported' {
                It 'Should not throw an error' {
                    { Assert-Module -ModuleName $testModuleName } | Should -Not -Throw

                    Assert-MockCalled -CommandName Import-Module -Exactly -Times 0
                }
            }

            Context 'When module should be imported' {
                It 'Should not throw an error' {
                    { Assert-Module -ModuleName $testModuleName -ImportModule } | Should -Not -Throw

                    Assert-MockCalled -CommandName Import-Module -Exactly -Times 1
                }
            }
        }
    }

    Describe 'WebApplicationProxyDsc.Common\Get-WebApplicationProxyConfigurationStatus' {
        BeforeAll {
            $mockGetItemPropertyProxyConfigurationStatusNotConfigured0Result = @{
                ProxyConfigurationStatus = 0
            }
            $mockGetItemPropertyProxyConfigurationStatusNotConfigured1Result = @{
                ProxyConfigurationStatus = 1
            }
            $mockGetItemPropertyProxyConfigurationStatusConfiguredResult = @{
                ProxyConfigurationStatus = 2
            }
            $mockUnexpectedStatus = 99
            $mockGetItemPropertyProxyConfigurationStatusUnexpectedResult = @{
                ProxyConfigurationStatus = $mockUnexpectedStatus
            }
        }

        Context 'When the WebApplicationProxy Configuration Status is Configured' {
            BeforeAll {
                Mock -CommandName Get-ItemProperty -MockWith { $mockGetItemPropertyProxyConfigurationStatusConfiguredResult }
            }

            It 'Should return the correct result' {
                Get-WebApplicationProxyConfigurationStatus | Should -Be 'Configured'
            }

            It 'Should call the correct mocks' {
                Assert-MockCalled -CommandName Get-ItemProperty `
                    -ParameterFilter { $Path -eq 'HKLM:\SOFTWARE\Microsoft\ADFS' } `
                    -Exactly -Times 1
            }
        }

        Context 'When the WebApplicationProxy Configuration Status is NotConfigured with a value of 1' {
            BeforeAll {
                Mock -CommandName Get-ItemProperty -MockWith { $mockGetItemPropertyProxyConfigurationStatusNotConfigured0Result }
            }

            It 'Should return the correct result' {
                Get-WebApplicationProxyConfigurationStatus | Should -Be 'NotConfigured'
            }

            It 'Should call the correct mocks' {
                Assert-MockCalled -CommandName Get-ItemProperty `
                    -ParameterFilter { $Path -eq 'HKLM:\SOFTWARE\Microsoft\ADFS' } `
                    -Exactly -Times 1
            }
        }

        Context 'When the WebApplicationProxy Configuration Status is NotConfigured with a value of 2' {
            BeforeAll {
                Mock -CommandName Get-ItemProperty -MockWith { $mockGetItemPropertyProxyConfigurationStatusNotConfigured1Result }
            }

            It 'Should return the correct result' {
                Get-WebApplicationProxyConfigurationStatus | Should -Be 'NotConfigured'
            }

            It 'Should call the correct mocks' {
                Assert-MockCalled -CommandName Get-ItemProperty `
                    -ParameterFilter { $Path -eq 'HKLM:\SOFTWARE\Microsoft\ADFS' } `
                    -Exactly -Times 1
            }
        }

        Context 'When Get-ItemProperty throws an error' {
            BeforeAll {
                Mock -CommandName Get-ItemProperty -MockWith { Throw 'Error' }
            }

            It 'Should throw the correct error' {
                { Get-WebApplicationProxyConfigurationStatus } | Should -Throw $script:localizedData.ConfigurationStatusNotFoundError
            }
        }

        Context 'When ProxyConfigurationStatus is an unexpected value' {
            BeforeAll {
                Mock -CommandName Get-ItemProperty -MockWith { $mockGetItemPropertyProxyConfigurationStatusUnexpectedResult }
            }

            It 'Should throw the correct error' {
                { Get-WebApplicationProxyConfigurationStatus } | Should -Throw ($script:localizedData.UnknownConfigurationStatusError -f
                    $mockUnexpectedStatus)
            }
        }
    }
}
