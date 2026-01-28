$source = "c:\Users\USER\Desktop\tctsemtu site"
$destination = "$source\tctsemtu_godaddy_files.zip"
$extensions = @(".html", ".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".ico", ".svg", ".webp")

Set-Location -Path $source

# Get all matching files
$files = Get-ChildItem -File | Where-Object { $extensions -contains $_.Extension }

if ($files.Count -eq 0) {
    Write-Error "No matching files found to archive."
    exit 1
}

# Remove existing zip if it exists
if (Test-Path $destination) {
    Remove-Item $destination
}

# Create new zip
Compress-Archive -Path $files.FullName -DestinationPath $destination -Force

Write-Host "Successfully created archive: $destination"
Write-Host "Total files included: $($files.Count)"
Write-Host "File List:"
$files.Name
