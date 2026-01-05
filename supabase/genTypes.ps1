# Save this script as generate_supabase_types.ps1

# Define the project ID and the schemas
$projectId = "tpzfoendnhkizbmyslxo"
$schemas = "public"

# Define the output file path
$outputFilePath = "./supabase.g.ts"

# Run the Supabase command
supabase gen types --lang="typescript" --project-id $projectId -s $schemas > $outputFilePath

# Print a success message
Write-Host "Supabase types generated successfully and saved to $outputFilePath"
