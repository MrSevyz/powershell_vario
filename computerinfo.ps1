# Get system information
$computerSystem = Get-WmiObject -Class Win32_ComputerSystem
$hostname = $computerSystem.Name
$serialNumber = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber.Trim()
$model = $computerSystem.Model

$memory = Get-WmiObject -Class Win32_PhysicalMemory
$ramQuantity = [math]::Round(($memory | Measure-Object -Property Capacity -Sum).Sum / 1GB)
$ramBanks = $memory.Count
$freeRamBanks = $ramBanks - ($memory | Where-Object { $_.ConfiguredClockSpeed -ne 0 }).Count

$processor = Get-WmiObject -Class Win32_Processor
$cpu = $processor.Name

$disk = Get-WmiObject -Class Win32_DiskDrive | Where-Object { $_.MediaType -ne 'Removable Media' } | Select-Object -First 1
$diskSize = [math]::Round($disk.Size / 1GB)
$diskModel = $disk.Model

$operatingSystem = Get-WmiObject -Class Win32_OperatingSystem
$osVersion = $operatingSystem.Caption

# Create a file with the hostname as the name
$fileName = "$hostname.txt"
$fileContent = @"
Hostname: $hostname
Serial Number: $serialNumber
Model: $model
Operating System: $osVersion
RAM Quantity: $ramQuantity GB
RAM Banks: $ramBanks
Free RAM Banks: $freeRamBanks
CPU: $cpu
Disk Size: $diskSize GB
Disk Model: $diskModel
"@

$fileContent | Out-File -FilePath $fileName -Encoding utf8

# Create a CSV file with the desired information
$csvFileName = "$hostname.csv"
$csvData = [PSCustomObject]@{
    "Hostname" = $hostname
    "Serial Number" = $serialNumber
    "Model" = $model
    "Operating System" = $osVersion
    "RAM Quantity (GB)" = $ramQuantity
    "RAM Banks" = $ramBanks
    "Free RAM Banks" = $freeRamBanks
    "CPU" = $cpu
    "Disk Size (GB)" = $diskSize
    "Disk Model" = $diskModel
}

$csvData | Export-Csv -Path $csvFileName -NoTypeInformation

# Remove the header line from the CSV file
(Get-Content -Path $csvFileName) | Select-Object -Skip 1 | Set-Content -Path $csvFileName

Write-Host "System information saved to $fileName and $csvFileName"
