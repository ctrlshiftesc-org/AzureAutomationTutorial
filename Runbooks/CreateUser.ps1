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

### Import credential asset as a variable
    $credential = Get-AutomationPSCredential -Name 'AutomationUserService'

### Connect to Azure AD and suppress the output
    Connect-AzureAD -Credential $credential | out-null

### Combine first and last names for the display name
    $displayName = $givenName.Trim() + " " + $surname.Trim()

### Create UserPrincipalName
    $userPrincipalName = $givenName.Trim() + "." + $surname.Trim() + "@chaostechops.com"

### Create mail nickname
    $mailNickname = $givenName.Trim() + "." + $surname.Trim()

### Run separate runbook to generate password and store it in a variable
$pwd = .\PasswordGenerator.ps1

### Create a new password profile and set it to the generated password
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = $pwd
write-verbose "Created password profile"

### Create the new user with the input paramaters
     New-AzureADUser `
        -GivenName $givenName `
        -DisplayName $displayName `
        -JobTitle $jobTitle `
        -State $state `
        -TelephoneNumber $telephoneNumber `
        -Mobile $mobile `
        -PasswordProfile $PasswordProfile `
        -UserPrincipalName $userPrincipalName `
        -MailNickName $mailNickname `
        -AccountEnabled $true 

### Write account info to logs
write-verbose $userPrincipalName 
write-verbose $pwd