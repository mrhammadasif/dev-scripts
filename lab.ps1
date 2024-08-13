. "$($PSScriptRoot)/common/repos.ps1"

# $Dictionary = @{}

Get-AllFolders | ForEach-Object {
  Write-Host "###### $($_) #####" -ForegroundColor Yellow
  # Change the directory to the current folder
  Set-Location "$RootPath/$_"
  # $branch = (git branch | Select-String -Pattern "9455").Line?.TrimStart()
  # if($branch -Match "\* ") {
  #   $branch = $branch.Substring(2)
  # }
  # $proj = $_
  # git branch --all
  # $branches = git branch | cut -c3-
  $branches = git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short)+++%(refname:short)'
  $branches | ForEach-Object {
    $branch = $_.Trim()
    # Get the date and compare it how old it is
    $date = $branch.Split("+++")[0]
    $date = [datetime]::Parse($date)
    $diff = (Get-Date) - $date
    $branch = $branch.Split("+++")[1]
    if ($branch -eq "main") {
      return
    }
    if ($branch -eq "development") {
      return
    }
    if ($diff.Days -lt 21) {
      Write-Host "$branch" -ForegroundColor Gray
      return
    }
    Write-Host "$branch" -ForegroundColor Red
    git branch -D $branch
    # git remove branch
  }
  
  # if ($branch -ne $null) {
  #   Write-Host "$branch" -ForegroundColor Yellow
  #   git checkout -q $branch
  # }
  #  else {
  #   Write-Host "Branch not found" -ForegroundColor Red
  #   git checkout -q main
  #   git checkout -B bug/9455-SecurityVuln
  # }
  # $match = git branch | Select-String -Pattern "9455"
  # if($match.Line -ne $null) {
  #   Write-Host "$($match.Line.Substring(2))" -ForegroundColor Yellow
  # }
}

# Write-Host ""
# Write-Host ""
# Write-Host "###### Repositories #####" -ForegroundColor Green
# Write-Host $Dictionary
# $Dictionary | ForEach-Object {
#   Write-Host "$($_.Key) - $($_.Value)" -ForegroundColor Yellow
# }
# convert dictionary to JSON
# $Dictionary | ConvertTo-Json | Out-File "$RootPath/repositories.json"

Reset-ClI