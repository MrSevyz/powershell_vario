# Hexadecimal SID string from ms-DS-CreatorSID
$hexSID = "01 05 00 00 00 00 00 05 15 00 00 00 1A 72 34 DB AD F1 70 28 F1 AF 24 3C 36 08 00 00"

# Split the hex string into an array of strings representing byte values
$sidBytes = $hexSID -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }

# Convert the array to a .NET byte array type
$byteArray = [Byte[]] $sidBytes

# Create a SecurityIdentifier object using the byte array
try {
    $sid = New-Object System.Security.Principal.SecurityIdentifier($byteArray, 0)
    # Convert SID to readable form (S-1-5-21-...)
    $sidString = $sid.Value
    Write-Output "SID String: $sidString"

    # Resolve the SID to a username
    $user = $sid.Translate([System.Security.Principal.NTAccount])
    Write-Output "User: $($user.Value)"
}
catch {
    Write-Error "Failed to convert SID: $_"
}
