# Create Application Insights linked to the Log Analytics workspace
az monitor app-insights component create `
  -g $RG -l $LOC -a $AI `
  --kind web `
  --application-type web `
  --workspace $LAW_ID

# Fetch AI connection string and instrumentation key
$AI_CONN = az monitor app-insights component show -g $RG -a $AI --query connectionString -o tsv
$AI_KEY  = az monitor app-insights component show -g $RG -a $AI --query instrumentationKey -o tsv

$AI_CONN
$AI_KEY