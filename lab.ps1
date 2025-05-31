. "$($PSScriptRoot)/common/repos.ps1"

$author = "Hammad Asif"

# $Dictionary = @{}
$Folders = Get-ChildItem -Directory -Name
$Folders | ForEach-Object {
  # Write-Host "###### $($_) #####" -ForegroundColor Yellow
  # Change the directory to the current folder
  # Set-Location "$RootPath/$_"
  
  $gitFileName = "$($_)/.git/config"
  # if exists

  If (Test-Path $gitFileName) {
    Write-Host "###### $($_) #####" -ForegroundColor Yellow
    # Get the remote URL from the .git/config file
    # $remoteUrl = (Get-Content $gitFileName | Select-String -Pattern 'url = (.*)' | ForEach-Object { $_.Matches.Groups[1].Value })[0]
    # Write-Host "Remote URL: $remoteUrl"
    # $Dictionary[$_]= $remoteUrl
    # code $gitFileName
    # az branches list --repository "$($_)"
    $branchesOnline = az repos ref list --repository "$($_)" | & jq "[.[] | select((.creator.displayName | test($author))) | {name, displayName: .creator.displayName, email: .creator.uniqueName}]" | ConvertFrom-Json
    if($branchesOnline.Count -eq 0) {
      Write-Host "No branches found (created by $author) for repository: $($_)" -ForegroundColor Red
      return
    }
    $branchesOnline | ForEach-Object {  
      $branchName = $_.name
      $displayName = $_.displayName
      $email = $_.email
      Write-Host "Branch: {$branchName}, Creator: {$displayName}, Email: {$email}"
      
      # if branchName contains "main" or "development" then skip
      if ($branchName -like "*main*" -or $branchName -like "*development*") {
        return
      }
      if ($branchName -like "*rel/*") {
        return
      }
      $prs = az repos pr list --source-branch "$branchName" | jq '[.[] | {title, url, status, pullRequestId}]' | ConvertFrom-Json
      if($prs.Count -eq 0) {
        Write-Host "No PRs found for branch: $branchName" -ForegroundColor Red
        return
      }
      $prs | Format-Table pullRequestId,status,title -AutoSize
    }

  }

  
  # git checkout main
  # git branch --show
  # git fetch --all
  # git pull --rebase origin main
  # git status
}

Reset-ClI