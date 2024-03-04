#!/usr/bin/env node
import yargs from 'yargs'
import { hideBin } from 'yargs/helpers'
import { banner } from './common/utils.mjs'
import { AppNames, Apps } from './common/directories.mjs'
import { execSync } from 'child_process'

const yarg = yargs( hideBin( process.argv ) )


yarg.command( "stageall", "Stage all Files", ( args ) => {
  console.log( "Staging all files", args )
} )

yarg.command( "status", "Status of Repos", ( args ) => {
  AppNames.forEach(appName => {
    banner(appName)
    const response = execSync(`git status`, { cwd: Apps[appName].path })
    console.log(response.toString())
  });
})

const args = yarg.parse()