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
    
    git stash -u "before-cleaning-branches-${date}"
    git reset --hard

    git fetch --all --prune

    git checkout -q development
    git reset --hard origin/development
    
    git checkout -q main
    git reset --hard origin/main
    
  }
}

Reset-ClI
