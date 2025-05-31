#!/usr/bin/env node
import { Repos, AppNames, RepoNames } from "./common/directories.mjs"
import { execSync } from "child_process"
import prompts from "prompts"
import { banner, whichApps } from './common/utils.mjs'

/** @type {prompts.PromptObject[]} */

const questions = [
  {
    type: 'text',
    name: 'title',
    message: 'PR title',
    validate: value => value.length > 0
  },
  {
    type: 'text',
    name: 'description',
    message: 'PR description',
    validate: value => value.length > 0
  },
  {
    type: 'text',
    name: 'targetBranch',
    message: 'Target branch',
    initial: 'main',
    validate: value => value.length > 0
  },
  {
    type: 'text',
    name: 'sourceBranch',
    message: 'Source branch',
    validate: value => value.length > 0
  },
  {
    type: 'list',
    name: 'reviewers',
    separator: ',',
    message: 'Reviewers (comma separated)',
    validate: value => ( value.includes( '@' ) && value.length > 0 ),
    initial: 'pablo@edwire.com',
  },
  {
    type: 'list',
    name: 'workItems',
    separator: ',',
    validate: value => value.length > 0,
    message: 'Work items (comma separated)'
  },
  {
    type: 'list',
    name: 'tags',
    separator: ',',
    validate: value => value.length > 0,
    message: 'Tags (comma separated)'
  },
  {
    type: 'confirm',
    name: 'open',
    message: 'Open PR in Browser',
    initial: false
  }
];

; ( async () => {
  const appChoices = await whichApps()
  
  // const confirmation = await prompts( {
  //   type: 'confirm',
  //   name: 'confirm',
  //   message: red(`Do you want to run this command?`),
  //   initial: true
  // } )

  // if(confirmation.confirm === true) {
    appChoices.forEach( appName => {
      const dir = Repos[appName].path
      // const repoName = Repos[appName].repo
      banner(appName, {
        title: 'Package.json Duplicates',
      })

      const cmd = `cat package.json | jq '.dependencies | keys | sort'`
      const deps = JSON.parse(execSync(cmd, { cwd: dir }))
      const cmd2 = `cat package.json | jq '.devDependencies | keys | sort'`
      const devDeps = JSON.parse(execSync(cmd2, { cwd: dir }))
      // console.table((deps))
      // console.table((devDeps))
      const commonDeps = deps.filter( dep => devDeps.includes( dep ) )
      console.log( `Common dependencies: ${commonDeps.length}` )
      console.table( commonDeps )
    } )
  // }


} )()