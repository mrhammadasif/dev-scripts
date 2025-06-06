. "$($PSScriptRoot)/common/repos.ps1"

# for each folder in the current directory, that Starts with EG.
Get-AllFolders | ForEach-Object {
  # Change the directory to the current folder
  Set-Location "$RootPath/$($_)"
  $gitFileName = ".git/config"
  $date = Get-Date -Format "yyyy-MM-dd"
  $repoName = $_

  If (Test-Path $gitFileName) {
    Write-Host "###### $repoName #####" -ForegroundColor Yellow
    Write-Host
  
  }
}

Reset-ClI
