#!/usr/bin/env node
import { AppNames, Apps } from "./common/directories.mjs"
import { execSync } from "child_process"
import yargs from 'yargs'
import { hideBin } from 'yargs/helpers'
import { printTable, banner } from './common/utils.mjs'
const yarg = yargs(hideBin(process.argv))

yarg.option("show", {
  alias: "s",
  type: "boolean",
  description: "Show PRs Details"
})

yarg.option("creator", {
  alias: "c",
  type: "string",
  default: "hammad@edwire.com",
  description: "PRs by creator"
})

yarg.option("reviewer", {
  alias: "r",
  type: "string",
  default: "pablo@edwire.com",
  description: "Reviewers added"
})

const args = yarg.parse()
let command = `az repos pr list`

if (args.creator) {
  command += ` --creator ${args.creator}`
}

if (args.reviewer) {
  command += ` --reviewer ${args.reviewer}`
}

console.log(`Running command: ${command}`)

AppNames.forEach(key => {
  const dir = Apps[key].path

  banner(key)
  const output = execSync(command, { cwd: dir })
  printTable(output)
});
