#!/usr/bin/env node
import yargs from 'yargs'
import { hideBin } from 'yargs/helpers'
import { banner, whichApps } from './common/utils.mjs'
import { execSync } from 'child_process'
import prompts from "prompts"
import { Repos } from './common/directories.mjs'
import { red } from 'kolorist'
import { green } from 'kolorist'

const yarg = yargs( hideBin( process.argv ) )

yarg.command( "stageall", "Stage all Files", async ( args ) => {
  const appChoices = await whichApps()
  appChoices.forEach( appName => {
    banner( appName, {
      title: 'Stage All',
    } )
    const response = execSync( `git add .`, { cwd: Repos[appName].path } )
    console.log( response.toString() )
  } )
} )

yarg.command("merge", "Merge Branch to Dev", async (args) => {
  const appChoices = [await whichApps('apps')]
  
  const resp = await prompts([
    {
      message: 'Merge current branch into development',
      name: "merge",
      type: 'confirm',
      initial: true,
    },
  ], {
    onCancel: () => {
      process.exit(1)
    }
  })

  if(resp.merge === false) {
    console.log(red("Aborted"))
    return process.exit(1)
  }
  const processed = appChoices.map(async appName => {
    const targetBranch = (execSync('git branch --show', { cwd: Repos[appName].path }).toString()).trim()
    banner(appName, {
      title: 'Merge',
    })

    try {

      const statusOutput = (execSync('git diff-index HEAD --stat', { cwd: Repos[appName].path }).toString())
      const isClean = statusOutput.trim().length === 0
      if (!isClean) {
        console.error(red('Your working directory is not clean. Please commit or stash your changes before proceeding.'))
        console.log(statusOutput)
        return appName
      }
      console.log(execSync(`git checkout -q development`, { cwd: Repos[appName].path }).toString())
      console.log(execSync(`git pull origin development`, { cwd: Repos[appName].path }).toString())
      console.log(execSync(`git merge ${targetBranch}`, { cwd: Repos[appName].path }).toString())
      console.log(execSync(`git push origin development`, { cwd: Repos[appName].path }).toString())
      console.log(execSync(`git checkout -q ${targetBranch}`, { cwd: Repos[appName].path }).toString())
      return true
    } catch (error) {
      console.error(error)
      return appName
    }
  })
  const result = await Promise.all(processed)
  const errorful = result.filter(p => typeof p === 'string')

  if (errorful.length > 0) {
    console.log(red(`Errors in : ${errorful}`))
  }
  else {
    console.log(green(`All Processed`))
  }
})


yarg.command( "latest", "Fetch Latest", async ( _args ) => {
  const args = await _args.option( "branchname", {
    message: 'Branch Name',
    alias: 'b',
    demandOption: true,
  } ).parse()

  const appChoices = await whichApps()
  const processed = appChoices.map( async appName => {

    const resolvedBranchName = args.branchname

    banner( appName, {
      title: 'Branch',
    } )
    try {
      const statusOutput = ( execSync( 'git diff-index HEAD --stat', { cwd: Repos[appName].path } ).toString() )
      const isClean = statusOutput.trim().length === 0
      if ( !isClean ) {
        console.error( red( 'Your working directory is not clean. Please commit or stash your changes before proceeding.' ) )
        console.log( statusOutput )
        return appName
      }
      console.log( execSync( `git checkout -q ${resolvedBranchName}`, { cwd: Repos[appName].path } ).toString() )
      console.log( execSync( `git fetch origin ${resolvedBranchName}`, { cwd: Repos[appName].path } ).toString() )
      console.log( execSync( `git pull origin ${resolvedBranchName}`, { cwd: Repos[appName].path } ).toString() )
      return true
    } catch ( error ) {
      return appName
    }
  } )
  const result = await Promise.all( processed )
  const errorful = result.filter( p => typeof p === 'string' )

  if ( errorful.length > 0 ) {
    console.log( red( `Errors in : ${errorful}` ) )
  }
  else {
    console.log( green( `All Processed` ) )
  }
} )

yarg.command( "branchbydate", "Get Branch Last Updated Date", async ( args ) => {
  const appChoices = await whichApps()
  appChoices.forEach(app => {
    console.log(execSync(`git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short) %(refname:short)'`, { cwd: Repos[app].path }).toString())
  })
})

yarg.command( "branch", "Checkout Branch", async ( args ) => {
  const appChoices = await whichApps()
  const resp = await prompts( [
    {
      message: 'Branch to Checkout',
      name: "branch",
      type: 'autocomplete',
      choices: [
        'main',
        'development',
        'other'
      ].map( branch => ( {
        title: branch,
        value: branch,
        selected: branch === 'main' ? true : false
      } ) )
    },
    {
      message: '(Other) Branch Name',
      name: "branchName",
      type: prev => prev == 'other' ? 'text' : null,
      initial: 'main',
    },
    {
      message: 'Pull Latest',
      name: "getLatest",
      type: 'confirm',
      initial: true,
    }
  ], {
    onCancel: () => {
      process.exit( 1 )
    }
  } )
  const processed = appChoices.map( async appName => {

    const resolvedBranchName = resp.branch === 'other' ? resp.branchName : resp.branch

    banner( appName, {
      title: 'Branch',
    } )

    try {

      const statusOutput = ( execSync( 'git diff-index HEAD --stat', { cwd: Repos[appName].path } ).toString() )
      const isClean = statusOutput.trim().length === 0
      if ( !isClean ) {
        console.error( red( 'Your working directory is not clean. Please commit or stash your changes before proceeding.' ) )
        console.log( statusOutput )
        return appName
      }
      console.log( execSync( `git checkout -q main`, { cwd: Repos[appName].path } ).toString() )
      if ( resp.getLatest ) {
        console.log( execSync( `git fetch origin main`, { cwd: Repos[appName].path } ).toString() )
        console.log( execSync( `git pull origin main`, { cwd: Repos[appName].path } ).toString() )
      }
      if ( resolvedBranchName !== 'main' ) {
        console.log( execSync( `git checkout -B ${resolvedBranchName}`, { cwd: Repos[appName].path } ).toString() )
      }
      return true
    } catch ( error ) {
      return appName
    }
  } )
  const result = await Promise.all( processed )
  const errorful = result.filter( p => typeof p === 'string' )

  if ( errorful.length > 0 ) {
    console.log( red( `Errors in : ${errorful}` ) )
  }
  else {
    console.log( green( `All Processed` ) )
  }
} )

yarg.command( "status", "Status of Repos", async ( args ) => {
  const appChoices = await whichApps()
  appChoices.forEach( appName => {
    banner( appName, {
      title: 'Status',
    } )
    const response = execSync( `git status`, { cwd: Repos[appName].path } )
    console.log( response.toString() )
  } )
} )

yarg.completion().help().version( '1.0' ).showHelpOnFail( true )
  .demandCommand( 1, red( 'You need at least one command before moving on' ) )
  .strictCommands()
  .parse()