. "$($PSScriptRoot)/common/repos.ps1"

$DockerFile = "$RootPath/scripts/edgraph-services-hammad.yml"

# for each folder in the current directory, that Starts with EG.
Get-AllFolders | ForEach-Object {
  Write-Host "###### $($_) #####" -ForegroundColor Cyan

  # Change the directory to the current folder
  Set-Location "$RootPath/$_"
  $branch = git branch --show
  if ($branch -ne "development") {
    Write-Host "Checking out development branch" -ForegroundColor Green
    git checkout -q development
  }
  # if the branch is still not development, then skip
  if ($branch -ne "development") {
    Write-Host "Skipping $_" -ForegroundColor Red
    return
  }
}
# docker compose -f $DockerFile pull
# docker compose -f $DockerFile build
docker compose -f $DockerFile up -d

Reset-ClI