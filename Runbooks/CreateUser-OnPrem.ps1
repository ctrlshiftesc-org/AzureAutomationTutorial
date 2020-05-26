param (
		[Parameter(Mandatory=$true)]
			[string] $givenName,

        [Parameter(Mandatory=$true)]
			[string] $surname,

        [Parameter(Mandatory=$true)]
			[string] $jobTitle,

        [Parameter(Mandatory=$true)]
			[string] $state,

        [Parameter(Mandatory=$true)]
			[string] $telephoneNumber,

        [Parameter(Mandatory=$false)]
			[string] $mobile
	)

### Force runbook failure on error
    $ErrorActionPreference = "Stop"

### Import onprem credential asset as a variable
    $credential = Get-AutomationPSCredential -Name 'HybridService'

### Connect to AD and suppress the output
    Import-Module ActiveDirectory -Verbose:$false

### Combine first and last names for the display name
    $displayName = $givenName.Trim() + " " + $surname.Trim()

### Create name
    $name = $givenName.Trim() + "." + $surname.Trim()

### Create UserPrincipalName
    $userPrincipalName = $givenName.Trim() + "." + $surname.Trim() + "@chaostechops.com"

### Create date time variable
    $dateTime = Get-Date -Format "dddd MM/dd/yyyy HH:mm"

### Run separate runbook to generate password and store it in a variable
    $pwd = .\PasswordGenerator.ps1
    $securepwd = ConvertTo-SecureString -String $pwd -AsPlainText -Force

### Create the new user with the input paramaters
     New-ADUser `
        -GivenName $givenName `
        -Surname $surname `
        -DisplayName $displayName `
        -Name $name `
        -Title $jobTitle `
        -State $state `
        -OfficePhone $telephoneNumber `
        -MobilePhone $mobile `
        -AccountPassword $securepwd `
        -UserPrincipalName $userPrincipalName `
        -Enabled $True `
        -Description "Created with Azure Automation on $dateTime" `
        -Credential $credential

### Write account info to logs
write-verbose $name 
write-verbose $pwd