# Get the directory
$RootPath = "~/projects/edwire"

# Write-Host "Root Directory: $RootPath" -ForegroundColor Green
# $Continue = Read-Host "Do you want to continue in this directory? (Y/N)"
# if($Continue -ne "Y") {
#   exit
# }

if(-Not (Test-Path $RootPath)) {
  Write-Host "Directory not found" -ForegroundColor Red
  exit
}

# Confirm if user want to create the directory
Set-Location $RootPath

[string[]] $ReposToIgnore = @(
  "EG.HelmChart",
  "EG.DevOps"
)

function Get-AllFolders {
  return Get-ChildItem -Directory -Name | Where-Object { $_ -Match "^EG." -and $ReposToIgnore -notcontains $_ }
}

function Reset-Cli {
  Set-Location $RootPath
}