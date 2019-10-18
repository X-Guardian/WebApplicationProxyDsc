# Welcome to the WebApplicationProxyDsc wiki

Here you will find all the information you need to make use of the WebApplicationProxyDsc DSC resources in the
latest release (the code that is part of the master branch). This includes details of the
resources that are available, current capabilities and known issues, and information to help
plan a DSC based implementation of ActiveDirectoryDsc.

Please leave comments, feature requests, and bug reports in the
[issues section](https://github.com/X-Guardian/WebApplicationProxyDsc/issues) for this module.

## Getting started

To get started download WebApplicationProxyDsc from the [PowerShell Gallery](http://www.powershellgallery.com/packages/WebApplicationProxyDsc/)
and then unzip it to one of your PowerShell modules folders
(such as $env:ProgramFiles\WindowsPowerShell\Modules).

To install from the PowerShell gallery using PowerShellGet (in PowerShell 5.0 and above)
run the following command:

```powershell
Install-Module -Name WebApplicationProxyDsc -Repository PSGallery
```

To confirm installation, run the below command and ensure you see the WebApplicationProxyDsc
DSC resources available:

```powershell
Get-DscResource -Module WebApplicationProxyDsc
```
