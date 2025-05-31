// @ts-check
import * as kolors from "kolorist"
const maxLength = 80
import { Repos, AppNames, ServiceNames } from "./directories.mjs"
import prompts from 'prompts'
import yargs from 'yargs'
import { hideBin } from 'yargs/helpers'
const yarg = yargs( hideBin( process.argv ) )

export function padCenter ( string ) {
  const pad = maxLength - string.length
  const left = Math.floor( pad / 2 )
  const right = Math.ceil( pad / 2 )
  return "-".repeat( left ) + string + "-".repeat( right )
}

/** 
 * @param {'apps' | 'services' | undefined} choice
 * @param {boolean} single
*/
export async function whichApps (choice, single = false) {
  yarg.option("apps", {
    type: 'boolean',
    default: choice === 'apps'
  })
  yarg.option("services", {
    type: 'boolean',
    default: choice === 'services'
  })
  const args = await yarg.parse()
  let types = await prompts({
    type: ( args.apps || args.services ) === true  ? null : single ? 'autocomplete' : 'autocompleteMultiselect',
    name: 'types',
    message: 'Select Repos',
    choices: [
      {
        title: 'Apps',
        value: 'apps',
        selected: true
      },
      {
        title: 'Services',
        value: 'services',
        selected: false
      }
    ],
  }, { onCancel () { process.exit() } } )
  if(( args.apps || args.services ) === true) {
    types = {
      types: [
        args.apps ? 'apps' : '',
        args.services ? 'services' : ''
      ]
    }
  }
  const repos = [
    ...( types.types.includes( 'apps' ) ? AppNames : [] ),
    ...( types.types.includes( 'services' ) ? ServiceNames : [] ),
  ]
  const resp = await prompts( {
    type: single ? 'autocomplete' : 'autocompleteMultiselect',
    name: 'repos',
    message: 'Select Repos',
    choices: repos.map( appName => ( {
      title: appName,
      value: appName,
      selected: false
    } ) ),
  }, { onCancel () { process.exit() } } )
  return resp.repos || []
}

export function banner ( appName, _options = {} ) {
  const defaults = {
    color: kolors.cyan,
    title: ''
  }
  const opts = {
    ...defaults,
    ..._options,
  }
  const app = Repos[appName]
  console.log( opts.color( padCenter( '' ) ) )
  console.log( opts.color( padCenter( `[${app.repo}] -> (${opts.title || 'Output'}) ` ) ) )
  console.log( opts.color( padCenter( '' ) ) )
}

export function printTable ( output ) {
  const prs = JSON.parse( output.toString() )
  console.log( `PRs count: ${prs.length}` )
  if ( prs.length === 0 ) {
    return
  }
  console.table( prs.map( pr => {
    return {
      'PR Id': pr.codeReviewId,
      Title: pr.title,
      Status: pr.status,
      CreatedBy: pr.createdBy.displayName,
      Reviewers: pr.reviewers.map( r => r.displayName ).filter( f => !f.includes( 'EW.Educate' ) ).join( ", " ),
      Target: pr.targetRefName.replace( /refs\/heads\//, '' ),
      Source: pr.sourceRefName.replace( /refs\/heads\//, '' ),
    }
  } ) )
}