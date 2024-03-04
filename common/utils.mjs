import { cyan } from "kolorist"
const maxLength = 80
import { Apps } from "./directories.mjs"

export function padCenter ( string ) {
  const pad = maxLength - string.length
  const left = Math.floor( pad / 2 )
  const right = Math.ceil( pad / 2 )
  return "-".repeat( left ) + string + "-".repeat( right )

}

export function banner ( appName ) {
  const app = Apps[appName]
  console.log( cyan( padCenter( '' ) ) )
  console.log( cyan( padCenter( `[${app.repo}]` ) ) )
  console.log( cyan( padCenter( '' ) ) )
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