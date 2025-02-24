# Setup
$libDir = Get-Location
$spDir = "$libDir\apis\spotify"
$ytDir = "$libDir\apis\youtube"

$dockerSetup = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-win-amd64"

# Create directories
Write-Output "Directory Structure"

if (!(Test-Path "$spDir" -PathType Container)) {
    Write-Output "`tCreating 'lib\apis\spotify'"
    New-Item -Path "$spDir" -ItemType Directory > $null
}

if (!(Test-Path "$ytDir" -PathType Container)) {
    Write-Output "`tCreating 'lib\apis\youtube'"
    New-Item -Path "$ytDir" -ItemType Directory > $null
}

Write-Output "`tVerified"

# Install Docker if required
Write-Output "Docker"

if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Output "`tDownloading Docker Desktop (Windows)"
    Invoke-WebRequest -Uri $dockerSetup -OutFile "$libDir\docker-installer.exe"

    Write-Output "`tInstalling Docker Desktop"
    Start-Process "$libDir\docker-installer.exe" -Wait install

    Write-Output "`tCleaning Residual Files"
    Remove-Item "$libDir\docker-installer.exe"  > $null
}

Write-Output "`tVerified"

# Generate APIs: Spotify
Write-Output "Spotify API"

Write-Output "`tGenerating API"
docker run --rm -v "${spDir}:/local" openapitools/openapi-generator-cli generate `
    -i https://raw.githubusercontent.com/sonallux/spotify-web-api/refs/heads/main/fixed-spotify-open-api.yml `
    -g dart `
    -o /local `
    > $null
    
Write-Output "`tCleaning Residual Files"
Get-ChildItem -Path "$spDir" | Where-Object { $_.Name -ne "lib" } | Remove-Item -Recurse -Force > $null
    
Write-Output "`tRestructuring API"
Move-Item -Path "$spDir\lib\*" -Destination "$spDir"
Remove-Item -Path "$spDir\lib" -Recurse -Force > $null
    
Write-Output "`tUpdating Dependencies"
dart pub add collection > $null
dart pub add http > $null
dart pub add intl > $null
dart pub add meta > $null

Write-Output "`tVerified"

# Generate APIs: YouTube
# Write-Output "YouTube API"

# Write-Output "`tGenerating API"
# docker run --rm -v "${ytDir}:/local" openapitools/openapi-generator-cli generate `
#     -i https://raw.githubusercontent.com/sonallux/youtube-web-api/refs/heads/main/fixed-youtube-open-api.yml `
#     -g dart `
#     -o /local `
#     > $null
    
# Write-Output "`tCleaning Residual Files"
# Get-ChildItem -Path "$ytDir" | Where-Object { $_.Name -ne "lib" } | Remove-Item -Recurse -Force > $null
    
# Write-Output "`tRestructuring API"
# Move-Item -Path "$ytDir\lib\*" -Destination "$ytDir"
# Remove-Item -Path "$ytDir\lib" -Recurse -Force > $null
    
# Write-Output "`tUpdating Dependencies"
# dart pub add collection > $null
# dart pub add http > $null
# dart pub add intl > $null
# dart pub add meta > $null

# Write-Output "`tVerified"