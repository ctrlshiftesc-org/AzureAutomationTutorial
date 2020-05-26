### Add input paramater(s) 
    param (
            [Parameter(Mandatory=$true)]
                [string] $userPrincipalName,
            
            [Parameter(Mandatory=$false)]
                [string] $optionalVariable = "Default String Value"
        )

### Force runbook failure on error
    $ErrorActionPreference = "Stop"

### Connect to AD and suppress the output
    Import-Module ActiveDirectory -Verbose:$false

### Find the account with the matching userPrincipalName and set it to a variable
    $userAccount = Get-ADUser -Filter {userPrincipalName -eq $userPrincipalName}

### Output the Display Name of the user
    Write-Output $userAccount.Name

## Output the optional variable
    Write-Output $optionalVariable
