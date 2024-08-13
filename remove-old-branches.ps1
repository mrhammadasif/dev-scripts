. "$($PSScriptRoot)/common/repos.ps1"

# Confirm if the user wants to delete the branches
$response = Read-Host "Do you want to delete the branches? (y/n)"
if ($response -ine "y") {
  Write-Host "Exiting..." -ForegroundColor Red
  exit
}
Write-Host "Deleting branches..." -ForegroundColor Green

Get-AllFolders | ForEach-Object {
  Write-Host "###### $($_) #####" -ForegroundColor Yellow
  # Change the directory to the current folder
  Set-Location "$RootPath/$_"
  $branches = git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short)+++%(refname:short)'
  $branches | ForEach-Object {
    $branch = $_.Trim()
    # Get the date and compare it how old it is
    $dateStr = $branch.Split("+++")[0]
    $date = [datetime]::Parse($dateStr)
    $diff = (Get-Date) - $date
    $branch = $branch.Split("+++")[1]
    if ($branch -eq "main") {
      return
    }
    if ($branch -eq "development") {
      return
    }

    # REMOVE BRANCHES OLDER THAN 30 DAYS
    if ($diff.Days -lt 30) {
      Write-Host "$branch (Not Deleting. Last Commit: $dateStr)" -ForegroundColor Gray
      return
    }
    Write-Host "Deleting: $branch" -ForegroundColor Red
    git branch -D $branch
  }
  
}

Reset-ClI