# Load the AMO and TOM libraries
Add-Type -AssemblyName "Microsoft.AnalysisServices.Tabular"
Add-Type -AssemblyName "Microsoft.AnalysisServices"

# Define the SSAS server and database
$serverName = "YourSSASServerName"
$databaseName = "YourDatabaseName"

# Define the partition name to process
$partitionName = "Partial"

# Connect to the SSAS server
$server = New-Object Microsoft.AnalysisServices.Server
$server.Connect($serverName)

# Get the SSAS Tabular database
$database = $server.Databases.FindByName($databaseName)

if ($database -ne $null) {
    try {
        $foundPartition = $false

        # Iterate through tables
        foreach ($table in $database.Model.Tables) {
            # Iterate through partitions
            foreach ($partition in $table.Partitions) {
                if ($partition.Name -eq $partitionName) {
                    $foundPartition = $true
                    # Request refresh on the partition
                    $partition.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Full)
                }
            }
        }

        if ($foundPartition) {
            # Save changes to process the partition(s)
            $database.Model.SaveChanges()
            Write-Host "Partition '$partitionName' processed successfully."
        }
        else {
            Write-Host "Partition '$partitionName' not found in any table."
        }
    } catch {
        Write-Host "An error occurred while processing the partition: $_"
    }
} else {
    Write-Host "Database '$databaseName' not found."
}

# Disconnect from the server
$server.Disconnect()
