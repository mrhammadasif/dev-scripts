#!/usr/bin/env node
import { Repos, AppNames, RepoNames } from "./common/directories.mjs"
import { execSync } from "child_process"
import { green } from 'kolorist'
import { red } from 'kolorist'
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
    initial: 'pablo@edwire.com,jayson@edwire.com,jf@edwire.com',
  },
  {
    type: 'list',
    name: 'workItems',
    separator: ',',
    validate: value => value.length > 0,
    message: 'Work items (comma separated)'
  },
  {
    type: 'confirm',
    name: 'open',
    message: 'Open PR in Browser',
    initial: true
  }
];

; ( async () => {
  const appChoices = await whichApps()
  const args = await prompts( questions, { onCancel: () => process.exit( 1 ) } )
  console.log( args )

  let command = `az repos pr create`
  // --repository "{repo}"
  if ( args.targetBranch ) {
    command += ` --target-branch "${args.targetBranch}"`
  }

  if ( args.sourceBranch ) {
    command += ` --source-branch "${args.sourceBranch}"`
  }

  if ( args.title ) {
    command += ` --title "${args.title}"`
  }

  if ( args.description ) {
    command += ` --description "${args.description}"`
  }

  if ( args.reviewers ) {
    command += ` --reviewers ${args.reviewers.map( r => `"${r}"` ).join(" ")}`
  }

  if ( args.workItems ) {
    command += ` --work-items ${args.workItems.map( r => `${r}` ).join(" ")}`
  }

  if ( args.open ) {
    command += ` --open`
  }
  console.log( `Running command: ${green(command)}` )
  console.log( ' --- ' )
  const confirmation = await prompts( {
    type: 'confirm',
    name: 'confirm',
    message: red(`Do you want to run this command?`),
    initial: true
  } )

  if(confirmation.confirm === true) {
    appChoices.forEach( appName => {
      const dir = Repos[appName].path
      const repoName = Repos[appName].repo
      const cmd = command.replace( /\{repo\}/g, repoName ).replace( /\{dir\}/g, dir )
      banner(appName, {
        title: 'Open PR'
      })
      const output = execSync( cmd, { cwd: dir } )
      console.log( output.toString() )
    } )
  }


} )()