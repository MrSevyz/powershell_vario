# Read the content of the file
$content = Get-Content -Path "in.txt"

# Process each line and remove the first n characters
$newContent = $content | ForEach-Object {
    if ($_.Length -ge 22) {
        $_.Substring(22)
    } else {
        # If the line is less than 72 characters, just output an empty line
        ""
    }
}

# Write the modified content back to the file
$newContent | Set-Content -Path "out.txt"