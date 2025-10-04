# Set subscription
az account set --subscription "afca76e1-8370-4362-a06b-13672e9a2e52"

# Install Application Insights extension (to avoid prompts)
az extension add -n application-insights --allow-preview true

# Variables (adjust ENV if you prefer)
$RG = "hw2-rg"
$LOC = "eastus"
$ENV = "dev"

# Existing Log Analytics workspace (you already created it)
$LAW = "hw2-law-$ENV"

# App Insights name
$AI = "hw2-ai-$ENV"

# App Service Plan and Web App names
$PLAN = "hw2-asp-$ENV"
$WEB  = "hw2-web-$ENV"

# Generate a random suffix for globally unique SQL Server name
$suffix = (Get-Random -Maximum 99999)
$SQLSERVER = "hw2-sql-$ENV-$suffix"
$SQLDB     = "hw2-db-$ENV"
$SQLADMIN  = "hw2sqladmin"

# Get the Log Analytics workspace ARM ID (used to link App Insights)
$LAW_ID = az monitor log-analytics workspace show -g $RG -n $LAW --query id -o tsv
$LAW_ID