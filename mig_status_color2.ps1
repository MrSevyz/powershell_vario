Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Data

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Exchange Online Migration Status"
$form.Size = New-Object System.Drawing.Size(1500,1000) # Increased height to 1000
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"

# Add a label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = "Enter User Principal Name:"
$form.Controls.Add($label)

# Add a textbox for username input
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(320,20)
$form.Controls.Add($textBox)

# Add a button to execute the script
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(340,38)
$button.Size = New-Object System.Drawing.Size(100,23)
$button.Text = "Get Status"
$form.Controls.Add($button)

# Add a DataGridView to display the results
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Location = New-Object System.Drawing.Point(10,80)
$dataGridView.Size = New-Object System.Drawing.Size(1470,880) # Increased height to 880
$dataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::AllCells
$form.Controls.Add($dataGridView)

# Add an event handler for the button click
$button.Add_Click({
    try {
        # Clear previous results
        $dataGridView.DataSource = $null

        # Get username from the textbox
        $username = $textBox.Text.Trim()

        # Connect to Exchange Online
        Connect-ExchangeOnline -UserPrincipalName $username -ShowProgress $true

        # Get all migration batches
        $migrationBatches = Get-MigrationBatch

        # Create a DataTable to hold the results
        $dataTable = New-Object System.Data.DataTable
        $null = $dataTable.Columns.Add("BatchId")
        $null = $dataTable.Columns.Add("Identity")
        $null = $dataTable.Columns.Add("StatusDetail")
        $null = $dataTable.Columns.Add("PercentageComplete")
        $null = $dataTable.Columns.Add("EstimatedTotalTransferSize")
        $null = $dataTable.Columns.Add("BytesTransferred")
        $null = $dataTable.Columns.Add("TotalItemsInSourceMailboxCount")
        $null = $dataTable.Columns.Add("SyncedItemCount")
        $null = $dataTable.Columns.Add("CreatedTime")
        $null = $dataTable.Columns.Add("LastSuccessfulSyncTime")

        # Loop through each migration batch
        foreach ($batch in $migrationBatches) {
            # Get migration user statistics for the current batch
            $migrationUsersStats = Get-MigrationUser -BatchId $batch.Identity | Get-MigrationUserStatistics

            # Loop through each migration user statistics
            foreach ($stats in $migrationUsersStats) {
                # Add a row to the DataTable
                $row = $dataTable.NewRow()
                $row["BatchId"] = $batch.Identity
                $row["Identity"] = $stats.Identity
                $row["StatusDetail"] = $stats.StatusDetail
                $row["PercentageComplete"] = $stats.PercentageComplete
                $row["EstimatedTotalTransferSize"] = $stats.EstimatedTotalTransferSize
                $row["BytesTransferred"] = $stats.BytesTransferred
                $row["TotalItemsInSourceMailboxCount"] = $stats.TotalItemsInSourceMailboxCount
                $row["SyncedItemCount"] = $stats.SyncedItemCount
                $row["CreatedTime"] = $stats.CreatedTime
                $row["LastSuccessfulSyncTime"] = $stats.LastSuccessfulSyncTime
                $null = $dataTable.Rows.Add($row)
            }
        }

        # Bind the DataTable to the DataGridView
        $dataGridView.DataSource = $dataTable
    } catch {
        Write-Host "Error occurred: $_"
    }
})

# Add CellFormatting event handler to color rows
$dataGridView_CellFormatting = {
    param (
        [System.Object]$sender,
        [System.Windows.Forms.DataGridViewCellFormattingEventArgs]$e
    )
    
    if ($e.RowIndex -ge 0) {
        $percentageComplete = [int]$dataGridView.Rows[$e.RowIndex].Cells["PercentageComplete"].Value
        
        if ($percentageComplete -ge 0 -and $percentageComplete -lt 25) {
            $e.CellStyle.BackColor = [System.Drawing.Color]::Red
        }
        elseif ($percentageComplete -ge 25 -and $percentageComplete -lt 50) {
            $e.CellStyle.BackColor = [System.Drawing.Color]::DarkOrange
        }
        elseif ($percentageComplete -ge 50 -and $percentageComplete -lt 75) {
            $e.CellStyle.BackColor = [System.Drawing.Color]::Orange
        }
        elseif ($percentageComplete -ge 75 -and $percentageComplete -lt 94) {
            $e.CellStyle.BackColor = [System.Drawing.Color]::yellow
        }
        elseif ($percentageComplete -ge 95) {
            $e.CellStyle.BackColor = [System.Drawing.Color]::LightGreen
        }
    }
}


$dataGridView.Add_CellFormatting($dataGridView_CellFormatting)

# Show the form
$form.ShowDialog() | Out-Null
