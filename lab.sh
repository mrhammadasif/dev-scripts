#!/usr/bin/env bash
source ./common/common

# enable error
set -E

# cd into each directory
for key in "${!Directories[@]}"; do
  echo "-------------------------"
  echo "---- Going to ${key} ----"
  cd ${Directories[$key]}
  # git checkout -B refactor/8099-UpgradeDeps
  # git merge fix/7950-SecurityAxios
  # git pull origin development
  # git branch --show-current
  # nr refresh-token
  # na list @edgraph/shared
  # code vite.config.ts

  # cat vite.config.ts | grep -e "reactivityTransform"

  # remove the line which contains text
  # sed -i '' '/sourceMap\: \!isProd/d' vite.config.ts

  # git add .
  # git commit -m "refactor: #8099 #8100 Remove the build-generated files from git and add them to gitignore"
  # git status
  # git reset --soft HEAD~1
  # git push origin refactor/8099-UpgradeDeps
  # git rm 
  # git untrack auto-import.d.ts file from git
  # git rm --cached src/components.d.ts

  # add the file to gitignore
  # echo "src/components.d.ts" >> .gitignore
  # echo "src/auto-imports.d.ts" >> .gitignore

  # code .gitignore
  
  # git unstage all
  # git checkout main
  # git checkout -B fix/8089-IndexNotRedirecting
  # git branch -m fix/8098-IndexNotRedirecting
  # git fetch
  # git add uno.config.ts
  # git pull origin main --rebase
  # git push origin --delete fix/8089-IndexNotRedirecting
  # git push origin fix/8098-IndexNotRedirecting
  # git branch --show-current

  # merge this branch into development
  # git checkout development
  # git merge fix/8098-IndexNotRedirecting
  # git checkout fix/8098-IndexNotRedirecting
  # git push origin fix/8098-IndexNotRedirecting
  az repos pr create --title "Fix the Redirection" --description "- fix the redirection (revert layouts plugin)\n- remove the unocss eslint plugin until team pushed a fix" --target-branch "main" --source-branch "fix/8098-IndexNotRedirecting" --open --repository "EG.Applications.Admin" --reviewers "pablo@edwire.com" --work-items 8098
  # git status
  # git push origin development

  # git status
  # ni vite-plugin-vue-layouts@0.7.0 --force
  # nun @unocss/eslint-plugin
  # git add package.json
  # git add pnpm-lock.yaml
  
  # git commit -m "bug: #8099 Redirection not working from index page"
  # echo "export { default } from '@edgraph/shared/unocss.config'" | tee uno.config.ts
  # git add uno.config.ts
  # git commit -m "refactor: #8099 fix double statements in unocss.config"
  # git rm unocss.config.ts
  # nr refresh-token
  # ni @edgraph/shared@latest --force

  # ni @edgraph/shared@1.2.0 --force
  # ni
  # nr lint --fix
  # nr build:prod
  # nr up
done