# List All Azure Reports
$JSON = az repos list --organization https://dev.azure.com/edwire --project EW.Educate --output json

# Convert JSON to PowerShell Object
$Object = $JSON | ConvertFrom-Json

# Get the directory
$RootPath = "~/projects/edwire-repos"

Write-Host "Root Directory: $RootPath" -ForegroundColor Green
$Continue = Read-Host "Do you want to continue in this directory? (Y/N)"
if($Continue -ne "Y") {
  exit
}

# Confirm if user want to create the directory
if(-Not (Test-Path $RootPath)) {
  $Continue2 = Read-Host "Directory not found. Do you want to create it? (Y/N)"
  if($Continue2 -ne "Y") {
    exit
  }
  New-Item -ItemType Directory -Path $RootPath
}

Set-Location $RootPath

# loop through each object in the array
$Object | ForEach-Object {
  if($_.name -Match "Z-Archived") {
    # skip the current iteration
    return
  }
  Write-Host "------ $($_.name) -----" -ForegroundColor Cyan
  # find if the file is already cloned
  if(Test-Path $_.name) {
    # skip the current iteration
    Write-Host "Already cloned" -ForegroundColor Red
    return
  }
  
  Write-Host "Cloning Main Branch" -ForegroundColor Yellow
  
  # Create a new Folder
  # mkdir $_.name
  
  # Git clone the development branch
  git clone $_.sshUrl $_.name -b main

  # Git clone the development branch
  Write-Host "Checkout Development branch" -ForegroundColor Yellow
  Set-Location $_.name
  git branch -f development origin/development
  git checkout development
  Set-Location ..
}