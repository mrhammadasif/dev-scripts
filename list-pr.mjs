#!/usr/bin/env node
import { Directories, DirectoriesRepo } from "./common/directories.mjs"
import { execSync } from "child_process"
import yargs from 'yargs'
import { hideBin } from 'yargs/helpers'
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

Object.keys(Directories).forEach(key => {
  const dir = Directories[key]
  const repoName = DirectoriesRepo[key]
  command = command.replace(/\{repo\}/g, repoName).replace(/\{dir\}/g, dir)
  console.log("-------------------------")
  console.log(`---- Going to [${key}] ----`)
  const output = execSync(command, { cwd: dir })
  if(args.show) {
    console.log(output.toString())
    return
  }
  const prs = JSON.parse(output.toString())
  console.log(`You have total ${prs.length} PRs pending`)
  if(prs.length === 0) {
    return
  }
  console.table(prs.map(pr => {
    return {
      Title: pr.title,
      Status: pr.status,
      CreatedBy: pr.createdBy.displayName,
      Reviewers: pr.reviewers.map(r => r.displayName).join(", "),
      Target: pr.targetRefName,
      Source: pr.sourceRefName
    }
  }))
});
