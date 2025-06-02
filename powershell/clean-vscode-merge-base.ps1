. "$($PSScriptRoot)/common/repos.ps1"

# $Dictionary = @{}
$Folders = Get-ChildItem -Directory -Name
$Folders | ForEach-Object {
  Write-Host "###### $($_) #####" -ForegroundColor DarkGray
  # Change the directory to the current folder
  Set-Location "$RootPath/$($_)"
  
  $gitFileName = "$RootPath/$($_)/.git/config"

  Write-Host "$gitFileName" -ForegroundColor Green
  # if exists

  If (Test-Path $gitFileName) {
    Write-Host "###### $($_) #####" -ForegroundColor Cyan
    code $gitFileName
    # gsed -i '/vscode-merge-base/d' $gitFileName
    Write-Host "Removed vscode-merge-base from $gitFileName" -ForegroundColor Yellow
  }

}

Reset-ClI