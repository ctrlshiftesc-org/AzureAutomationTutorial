### Add input paramater(s) 
    param (
            [Parameter(Mandatory=$true)]
                [string] $userPrincipalName,
            
            [Parameter(Mandatory=$false)]
                [string] $optionalVariable = "Default String Value"
        )

### Force runbook failure on error
    $ErrorActionPreference = "Stop"

### Import credential asset as a variable
    $credential = Get-AutomationPSCredential -Name 'AutomationUserService'

### Connect to Azure AD and suppress the output
    Connect-AzureAD -Credential $credential | out-null

### Find the account with the matching userPrincipalName and set it to a variable
    $userAccount = Get-AzureADUser -filter "userPrincipalName eq '$userPrincipalName'"

### Output the Display Name of the user
    Write-Output $userAccount.DisplayName

## Output the optional variable
    Write-Output $optionalVariable
