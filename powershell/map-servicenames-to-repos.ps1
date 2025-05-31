. "$($PSScriptRoot)/common/repos.ps1"

$Dictionary = @{}

Get-AllFolders | ForEach-Object {
  Write-Host "###### $($_) #####" -ForegroundColor Cyan
  # Change the directory to the current folder
  Set-Location "$RootPath/$_"
  # $branch = (git branch | Select-String -Pattern "9455").Line?.TrimStart()
  # if($branch -Match "\* ") {
  #   $branch = $branch.Substring(2)
  # }
  $proj = $_
  Get-ChildItem -Path "." -Recurse -Filter "azure-pipelines.yml" | ForEach-Object {
    # Write-Host "$($_.FullName)" -ForegroundColor Yellow
    # Get File content
    # -Context 0, 1 
    $repo = (Get-Content $_ | Select-String -Pattern "repository:")
    if($repo) {
      $repo | ForEach-Object {
        $repo = $_.Line?.Replace("repository: ", "")?.Trim()?.Replace("'", "")?.Replace('"', "").Replace("edgraph/", "")
        # $repo | Write-Host -ForegroundColor Yellow
        if(-Not ($Dictionary.ContainsKey($proj))) {
          $Dictionary.Add($proj, "$repo")
        }
        # $Dictionary.Add($proj, $repo)
        # $repo = $_.ToString().Trim().Split(":")[1].Trim()
      }
    } else {
      Write-Host "Repository not found" -ForegroundColor Red
    }
  }
  

  
  # git branch --show-current
  # if ($branch -ne $null) {
  #   Write-Host "$branch" -ForegroundColor Yellow
  #   git checkout -q $branch
  # } else {
  #   Write-Host "Branch not found" -ForegroundColor Red
  #   git checkout -q main
  #   git checkout -B bug/9455-SecurityVuln
  # }
  # $match = git branch | Select-String -Pattern "9455"
  # if($match.Line -ne $null) {
  #   Write-Host "$($match.Line.Substring(2))" -ForegroundColor Yellow
  # }
}

Write-Host ""
Write-Host ""
Write-Host "###### Repositories #####" -ForegroundColor Green
Write-Host $Dictionary
# $Dictionary | ForEach-Object {
#   Write-Host "$($_.Key) - $($_.Value)" -ForegroundColor Yellow
# }
# convert dictionary to JSON
$Dictionary | ConvertTo-Json | Out-File "$RootPath/repositories.json"

Reset-ClI