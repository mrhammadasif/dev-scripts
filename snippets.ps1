# $branch = (git branch | Select-String -Pattern "9455").Line?.TrimStart()

# if($branch -Match "\* ") {
#   $branch = $branch.Substring(2)
# }
# $proj = $_
# git branch --all
# $branches = git branch | cut -c3-


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

# Write-Host ""
# Write-Host ""
# Write-Host "###### Repositories #####" -ForegroundColor Green
# Write-Host $Dictionary
# $Dictionary | ForEach-Object {
#   Write-Host "$($_.Key) - $($_.Value)" -ForegroundColor Yellow
# }
# convert dictionary to JSON
# $Dictionary | ConvertTo-Json | Out-File "$RootPath/repositories.json"