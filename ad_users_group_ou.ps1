# Import the Active Directory module
Import-Module ActiveDirectory

# Get a list of all users in Active Directory
$users = Get-ADUser -Filter *
Write-Output "List of all AD users:"
$users | Select-Object Name, SamAccountName, DistinguishedName

# Get a list of all groups in Active Directory
$groups = Get-ADGroup -Filter *
Write-Output "List of all AD groups:"
$groups | Select-Object Name, DistinguishedName

# Get a list of all organizational units (OUs) in Active Directory
$ous = Get-ADOrganizationalUnit -Filter *
Write-Output "List of all OUs:"
$ous | Select-Object Name, DistinguishedName

# Loop through each group and get the members
foreach ($group in $groups) {
    Write-Output "Members of group $($group.Name):"
    Get-ADGroupMember -Identity $group.Name | Select-Object Name, SamAccountName, DistinguishedName
}
