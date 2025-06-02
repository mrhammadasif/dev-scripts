. "$($PSScriptRoot)/common/repos.ps1"

$author = "Hammad Asif"

# $Dictionary = @{}
$Folders = Get-ChildItem -Directory -Name
$Folders | ForEach-Object {
  # Write-Host "###### $($_) #####" -ForegroundColor Yellow
  # Change the directory to the current folder
  # Set-Location "$RootPath/$_"
  Set-Location "$RootPath/${$_}"
  $gitFileName = "$($_)/.git/config"
  $repoName = $_

  If (Test-Path $gitFileName) {
    Write-Host
    Write-Host "###### $repoName #####" -ForegroundColor Yellow
    Write-Host
    $jqargs = '[.[] | select((.creator.displayName | test("'
    $jqargs += $author
    $jqargs += '"))) | {name}]'
    $branchesOnline = az repos ref list --repository "$repoName" | & jq $jqargs | ConvertFrom-Json
    # filter the branches with main and development and "rel/" name
    $branchesOnline = $branchesOnline | Where-Object { $_.name -notlike "*main*" -and $_.name -notlike "*development*" -and $_.name -notlike "*rel/*" }
    if($branchesOnline.Count -eq 0) {
      Write-Host "No branches found" -ForegroundColor DarkGray
      Write-Host
      return
    }
    Write-Host "Visit URL: https://dev.azure.com/edwire/EW.Educate/_git/$repoName/branches" -ForegroundColor DarkGray
    Write-Host
  
    $branchesOnline | ForEach-Object {  
      $branchName = $_.name
      Write-Host "Branch: $($branchName.TrimStart("refs/heads/")):"
      $prs = az repos pr list --source-branch "$branchName" --repository "$repoName" | jq '[.[] | {title, url, status, pullRequestId}]' | ConvertFrom-Json
      if($prs.Count -eq 0) {
        Write-Host "No PRs found for branch: $branchName" -ForegroundColor DarkRed
        Write-Host
        return
      }

      # add a link to the PR to eaach pr
      $prs | ForEach-Object {
        $_.url = "https://dev.azure.com/edwire/EW.Educate/_git/$($repoName)/pullrequest/$($_.pullRequestId)"
      }

      $prs | Format-List pullRequestId,status,title,url
    }

  }
}

Reset-ClI