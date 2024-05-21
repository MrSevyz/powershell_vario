# Set the folder path
$folderPath = "C:\mypath"

# Get all .ovpn files in the folder and subfolders
$files = Get-ChildItem -Path $folderPath -Filter "*.ovpn" -Recurse

foreach ($file in $files) {
    # Read the content of the file
    $content = Get-Content $file.FullName -Raw
    
    # Check if the line exists
    if ($content -notmatch "line to add") {
        # Add the line to the content
        $content += "`line to add"

        # Write the modified content back to the file
        $content | Set-Content $file.FullName
        Write-Host "Line added to $($file.FullName)"
    }
    else {
        Write-Host "Line already exists in $($file.FullName)"
    }
}
