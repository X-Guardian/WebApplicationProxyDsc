$Module = '<Module>'
$ResourceName = $Module + 'ResourceName'

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
)

$NewDscResourceParams = @{
    Name         = "MSFT_$ResourceName"
    Property     = $Properties
    FriendlyName = $ResourceName
    ModuleName   = $Module + 'Dsc'
    Path         = '..\..'
}

New-xDscResource @NewDscResourceParams
