#!/usr/bin/env node
import {Directories, DirectoriesRepo} from "./common/directories.mjs"
// Ensure these named flags
// - title
// - description
// - target-branch
// - source-branch

const argv = import('yargs').then(yargs => {
  yargs.completion("completion", function(current, argv) {
    return ["--title", "--description", "--target-branch", "--source-branch", "--repository", "--reviewers", "--work-items"]
  }).argv
})

//  For login
//  > az devops login
//  provide new (PAT)

const allAppsKeys = Object.keys(Directories)

allAppsKeys.forEach(key => {
  const dir = Directories[key]
  const repoName = DirectoriesRepo[key]
  
  console.log("-------------------------")
  console.log(`---- Going to ${dir} ----`)
  // az repos pr create --title "Fix the Redirection" --description "- fix the redirection (revert layouts plugin)\n- remove the unocss eslint plugin until team pushed a fix" --target-branch "main" --source-branch "fix/8098-IndexNotRedirecting" --repository "EG.Applications.Admin" --reviewers "pablo@edwire.com" --work-items 8098
});

