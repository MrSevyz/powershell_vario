# Set the folder path where your .docx files are located
$folderPath = "C:\Path\To\Your\Folder"

# Get a list of .docx files in the folder
$docxFiles = Get-ChildItem -Path $folderPath -Filter *.docx

# Loop through the list and print each file
foreach ($file in $docxFiles) {
    Start-Process -FilePath $file.FullName -Verb Print
}
