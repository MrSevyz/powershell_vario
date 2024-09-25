# Path to the text file with the list of hostnames
$hostnameFile = "C:\Users\Administrator.FILIPPI\Desktop\pc-av.txt"

# Import the list of hostnames from the text file and convert to lowercase for consistent comparison
$hostnames = Get-Content -Path $hostnameFile | ForEach-Object { $_.ToLower() }

# Get all AD-joined computers and extract their names
$adComputers = Get-ADComputer -Filter * -Property Name | Select-Object -ExpandProperty Name | ForEach-Object { $_.ToLower() }

# Find AD-joined computers that are not in the list of hostnames
$computersNotInList = $adComputers | Where-Object { -not ($hostnames -contains $_) }

# Output the result
if ($computersNotInList.Count -gt 0) {
    Write-Output "The following AD-joined computers are not in the list:"
    $computersNotInList
} else {
    Write-Output "All AD-joined computers are in the list."
}
