Write-Host "Fetching dotfiles repo..." -ForegroundColor Cyan

# url of the files
$repoUrl = "https://github.com/marhund/win_dotfiles_rice/archive/refs/heads/main.zip"

# temporary saving
$zipPath = "$env:TEMP\dotfiles.zip"
$extractPath = "$env:USERPROFILE\Downloads\WindowsSetup"

# download + extract zip
Invoke-WebRequest -Uri $repoUrl -OutFile $zipPath
if (Test-Path $extractPath) { Remove-Item $extractPath -Recurse -Force }
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# nuke zip file
Remove-Item $zipPath -Force

# find and run the main script
# (Note: GitHub automatically adds '-main' to the extracted folder name) - AI said that so it must be true
$scriptPath = "$extractPath\win_dotfiles_rice-main\main.ps1"

Write-Host "Launching setup script..." -ForegroundColor Green
Set-ExecutionPolicy Bypass -Scope Process -Force
& $scriptPath
