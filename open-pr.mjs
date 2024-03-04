#!/usr/bin/env node
import { Apps, AppNames } from "./common/directories.mjs"
import { execSync } from "child_process"
import prompts from "prompts"

/** @type {prompts.PromptObject[]} */
const questions = [
  {
    type: 'autocompleteMultiselect',
    name: 'repos',
    message: 'Select Repos',
    choices: AppNames.map( dir => ( {
      title: dir,
      value: dir,
      selected: false
    } ) ),
  },
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
    message: 'Reviewers (comma separated)',
    validate: value => ( value.includes( '@' ) && value.length > 0 ),
    initial: 'pablo@edwire.com',
  },
  {
    type: 'list',
    name: 'workItems',
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
    command += ` --reviewers "${args.reviewers.join( ',' )}"`
  }

  if ( args.workItems ) {
    command += ` --work-items "${args.workItems.join( ',' )}"`
  }

  if ( args.open ) {
    command += ` --open`
  }
  console.log( `Running command: ${command}` )

  args.repos.forEach( appName => {
    const dir = Apps[appName].path
    const repoName = Apps[appName].repo
    const cmd = command.replace( /\{repo\}/g, repoName ).replace( /\{dir\}/g, dir )
    banner(appName)
    const output = execSync( cmd, { cwd: dir } )
    console.log( output.toString() )
  } )

} )()