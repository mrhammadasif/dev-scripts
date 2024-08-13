. "$($PSScriptRoot)/common/repos.ps1"

# for each folder in the current directory, that Starts with EG.
Get-AllFolders | ForEach-Object {
  Write-Host "###### $($_) #####" -ForegroundColor Cyan

  # Change the directory to the current folder
  Set-Location "$RootPath/$_"

  git fetch --all
  git checkout -q main
  git pull origin main --rebase
  git checkout -q development
  git pull origin development --rebase
}

Reset-ClI