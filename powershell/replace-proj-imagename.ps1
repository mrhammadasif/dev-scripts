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
  Get-ChildItem -Path "." -Recurse -Filter "azure-*.yml" | ForEach-Object {
    # Write-Host "$($_.FullName)" -ForegroundColor Yellow
    # Get File content
    # -Context 0, 1 
    $repo = (Get-Content $_ | Select-String -Pattern "repository:" -CaseSensitive)
    if($repo) {
      $repo | ForEach-Object {
        $repo = $_.Line?.Replace("repository: ", "")?.Trim()?.Replace("'", "")?.Replace('"', "")
        # $repo | Write-Host -ForegroundColor Yellow
        if(-Not ($Dictionary.ContainsKey("ewcontainerscus/$repo"))) {
          $Dictionary.Add("ewcontainerscus/$repo", $proj)
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
$Dictionary | ConvertTo-Json | Out-File "$RootPath/scripts/repos.json"s

$reposFile = "$RootPath/scripts/repos.txt"

Get-Content $reposFile | ForEach-Object {
  $line = $_
  $projFind = $Dictionary[$line]
  if($projFind) {
    Write-Host "Found: $line -> $projFind" -ForegroundColor Green
    (Get-Content $reposFile) | ForEach-Object {$_ -replace $line, $projFind} | Set-Content $reposFile
  } else {
    Write-Host "Not Found: $line" -ForegroundColor Red
  }
  # $projMatch = $line.Replace("ewcontainerscus/", "")

  # $proj = $line.Split(" - ")[0]
  # $repo = $line.Split(" - ")[1]
  # $Dictionary.Add($proj, $repo)
}
$find = "abc"
$replaceWith = "xyz"
# find and replace in text file
(Get-Content $reposFile) | ForEach-Object {$_ -replace $find, $replaceWith} | Set-Content $reposFile

Reset-ClI