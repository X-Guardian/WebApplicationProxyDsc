$Module = 'Wap'
$ResourceName = $Module + 'Test'

$Properties = @(
    New-xDscResourceProperty `
        -Name KeyProperty `
        -Type String `
        -Attribute Key `
        -Description 'Key Property.'
    New-xDscResourceProperty `
        -Name RequiredProperty `
        -Type String `
        -Attribute Required `
        -Description 'Required Property.'
    New-xDscResourceProperty `
        -Name WriteProperty `
        -Type String `
        -Attribute Required `
        -Description 'Write Property.'
    New-xDscResourceProperty `
        -Name ReadProperty `
        -Type String `
        -Attribute Read `
        -Description 'Read Property.'
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
