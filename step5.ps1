# Verify .NET framework setting
az webapp config show -g "hw2-rg" -n "hw2-web-dev" --query netFrameworkVersion -o tsv
# Expected: v4.0 (represents 4.x including 4.8)

# Verify connection strings
az webapp config connection-string list -g "hw2-rg" -n "hw2-web-dev" -o table

# If DefaultConnectionString is missing or wrong, set it again
$CONN_STR = ${CONN_STR}
if (-not $CONN_STR) {
  $SQLSERVER = "hw2-sql-dev-96386"
  $SQLDB     = "hw2-db-dev"
  $SecureSqlPass = Read-Host "Enter your SQL admin password (for hw2sqladmin) to rebuild the connection string" -AsSecureString
  $SQLPASS = (New-Object System.Net.NetworkCredential("", $SecureSqlPass)).Password
  $CONN_STR = "Server=tcp:$SQLSERVER.database.windows.net,1433;Initial Catalog=$SQLDB;Persist Security Info=False;User ID=hw2sqladmin;Password=$SQLPASS;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}
az webapp config connection-string set -g "hw2-rg" -n "hw2-web-dev" --settings DefaultConnectionString="$CONN_STR" --connection-string-type SQLAzure

# Step 1 — Add the publish profile secret in GitHub
# Azure Portal → Web App hw2-web-dev → Overview → Get publish profile → Download
# Copy the entire XML content
# GitHub → sashabatin/hw2-lab-template → Settings → Secrets and variables → Actions → New repository secret
# Name: AZUREAPPSERVICE_PUBLISHPROFILE
# Value: paste the XML