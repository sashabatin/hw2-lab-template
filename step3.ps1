# step3.ps1 use command below to run this script
# .\step3.ps1 -ResourceGroup "hw2-rg" -Env "dev" -SqlLocation "eastus2" -SqlAdmin "hw2sqladmin" -SqlServiceObjective "S0"
param(
  [string]$ResourceGroup = "hw2-rg",
  [string]$Env = "dev",
  [string]$SqlLocation = "eastus2",
  [string]$SqlAdmin = "hw2sqladmin",
  [string]$SqlServiceObjective = "S0"
)

# Unique SQL server name (global uniqueness required)
$suffix = (Get-Random -Maximum 99999)
$SQLSERVER = "hw2-sql-$Env-$suffix"
$SQLDB     = "hw2-db-$Env"

Write-Host "Creating SQL Server in region: $SqlLocation, name: $SQLSERVER"

# Prompt for a strong SQL admin password (secure input)
$SecureSqlPass = Read-Host "Enter a STRONG SQL admin password for $SqlAdmin" -AsSecureString
$SQLPASS = (New-Object System.Net.NetworkCredential("", $SecureSqlPass)).Password

# Create SQL Server in the chosen region
az sql server create -l $SqlLocation -g $ResourceGroup -n $SQLSERVER -u $SqlAdmin -p $SQLPASS

# Allow Azure services to access SQL Server
az sql server firewall-rule create -g $ResourceGroup -s $SQLSERVER -n AllowAzureServices --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

# Create SQL Database
az sql db create -g $ResourceGroup -s $SQLSERVER -n $SQLDB --service-objective $SqlServiceObjective

# Build ADO.NET connection string
$CONN_STR = "Server=tcp:$SQLSERVER.database.windows.net,1433;Initial Catalog=$SQLDB;Persist Security Info=False;User ID=$SqlAdmin;Password=$SQLPASS;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
Write-Host $CONN_STR

# Optional: export for later steps
Set-Variable -Name SQLSERVER -Value $SQLSERVER -Scope Global
Set-Variable -Name SQLDB -Value $SQLDB -Scope Global
Set-Variable -Name SQLPASS -Value $SQLPASS -Scope Global
Set-Variable -Name CONN_STR -Value $CONN_STR -Scope Global