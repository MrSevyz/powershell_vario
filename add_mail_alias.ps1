# Connect to Office 365
Connect-MsolService

# Get the list of users with email ending in "@domain.com"
$users = Get-MsolUser -All | Where-Object { $_.UserPrincipalName -like '*@domain.com' }

# Add the "@domain.it" alias to each user
foreach ($user in $users) {
    $aliases = $user.EmailAddresses | Where-Object { $_ -ne $user.UserPrincipalName }
    $aliases += $user.UserPrincipalName.Replace('@domain.com', '@domain.it')
    Set-MsolUser -UserPrincipalName $user.UserPrincipalName -AlternateEmailAddresses $aliases
}

Write-Host "Alias added successfully."
