# Vars
$RG  = "hw2-rg"
$LOC = "eastus"
$ENV = "dev"

$PLAN = "hw2-asp-$ENV"      # existing plan
$WEB  = "hw2-web-$ENV"      # single app we'll deploy to
$AI   = "hw2-ai-$ENV"

# Fetch Application Insights values
$AI_CONN = az monitor app-insights component show -g $RG -a $AI --query connectionString -o tsv
$AI_KEY  = az monitor app-insights component show -g $RG -a $AI --query instrumentationKey -o tsv

# Ensure SQL connection string exists; rebuild if missing
if (-not $CONN_STR) {
  $SQLSERVER = "hw2-sql-dev-96386"
  $SQLDB     = "hw2-db-dev"
  $SecureSqlPass = Read-Host "Enter your SQL admin password (for hw2sqladmin) to rebuild the connection string" -AsSecureString
  $SQLPASS = (New-Object System.Net.NetworkCredential("", $SecureSqlPass)).Password
  $CONN_STR = "Server=tcp:$SQLSERVER.database.windows.net,1433;Initial Catalog=$SQLDB;Persist Security Info=False;User ID=hw2sqladmin;Password=$SQLPASS;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}

# 1) Create Web App (Windows)
az webapp create -g $RG -p $PLAN -n $WEB

# 2) Set runtime: ASP.NET v4.8 (Task 1 requirement)
az webapp config set -g $RG -n $WEB --net-framework-version "v4.8"

# 3) Configure SQL connection string (name must be DefaultConnectionString)
az webapp config connection-string set -g $RG -n $WEB `
  --settings DefaultConnectionString="$CONN_STR" `
  --connection-string-type SQLAzure

# 4) Configure Application Insights settings (homework requirement)
az webapp config appsettings set -g $RG -n $WEB --settings `
  "Keys:ApplicationInsights:InstrumentationKey=$AI_KEY" `
  "APPINSIGHTS_INSTRUMENTATIONKEY=$AI_KEY" `
  "APPLICATIONINSIGHTS_CONNECTION_STRING=$AI_CONN"

# Verify
az webapp show -g $RG -n $WEB -o table
Write-Host "Web App URL: https://$WEB.azurewebsites.net/"