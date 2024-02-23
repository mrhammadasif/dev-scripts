#!/usr/bin/env node
import { Directories, DirectoriesRepo } from "./common/directories.mjs"
import { execSync } from "child_process"
import yargs from 'yargs'
import { hideBin } from 'yargs/helpers'
const yarg = yargs(hideBin(process.argv))

yarg.option("open", {
  alias: "o",
  type: "boolean",
  description: "Open PR in Browser"
})

yarg.option("title", {
  alias: "t",
  type: "string",
  demandOption: true,
  description: "PR title"
})

yarg.option("description", {
  alias: "d",
  type: "string",
  demandOption: true,
  description: "PR description"
})

yarg.option("targetBranch", {
  alias: "tb",
  type: "string",
  demandOption: true,
  description: "Target branch"
})

yarg.option("sourceBranch", {
  alias: "sb",
  type: "string",
  default: "main",
  description: "Source branch"
})

yarg.option("reviewers", {
  alias: "rv",
  type: "string",
  default: "pablo@edwire.com",
  description: "Reviewers (comma separated)"
})

yarg.option("workItems", {
  alias: "w",
  type: "string",
  description: "Work items (comma separated)"
})

const args = yarg.parse()
let command = `az repos pr create`

if (args.targetBranch) {
  command += ` --target-branch ${args.targetBranch}`
}

if (args.sourceBranch) {
  command += ` --source-branch ${args.sourceBranch}`
}

if (args.title) {
  command += ` --title "${args.title}"`
}

if (args.description) {
  command += ` --description "${args.description}"`
}

if (args.reviewers) {
  command += ` --reviewers ${args.reviewers}`
}

if (args.workItems) {
  command += ` --work-items ${args.workItems}`
}

if (args.open) {
  command += ` --open`
}

console.log(`Running command: ${command}`)

Object.keys(Directories).forEach(key => {
  const dir = Directories[key]
  const repoName = DirectoriesRepo[key]
  command = command.replace(/\{repo\}/g, repoName).replace(/\{dir\}/g, dir)
  console.log("-------------------------")
  console.log(`---- Going to [${key}] ----`)
  const output = execSync(command, { cwd: dir })
  console.log(output.toString())
});
