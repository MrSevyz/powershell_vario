# Import the Active Directory module
Import-Module ActiveDirectory

# Specify the path for the CSV file
$outputPath = "AD_Groups_and_Members.csv"

# Create an array to store group and member information
$groupMembersInfo = @()

# Get all groups from Active Directory
$groups = Get-ADGroup -Filter *

# Iterate through each group
foreach ($group in $groups) {
    # Get group members
    $members = Get-ADGroupMember -Identity $group

    # Iterate through each member and add them to the groupMembersInfo array
    foreach ($member in $members) {
        $groupMembersInfo += [PSCustomObject]@{
            GroupName = $group.Name
            MemberName = $member.Name
            MemberType = $member.ObjectClass
        }
    }
}

# Export group and member information to CSV
$groupMembersInfo | Export-Csv -Path $outputPath -NoTypeInformation

Write-Host "CSV file created: $outputPath"
