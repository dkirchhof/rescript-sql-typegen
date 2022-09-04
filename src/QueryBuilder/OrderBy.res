type direction = ASC | DESC

type t = {
  ref: Ref.anyRef,
  direction: direction,
}

let asc = ref => {
  {ref: ref->Ref.toAnyRef, direction: ASC}
}

let desc = ref => {
  {ref: ref->Ref.toAnyRef, direction: DESC}
}

let toSQL = (orderBy, queryToString) => {
  let refString = Ref.toSQL(orderBy.ref, queryToString)

  let directionString = switch orderBy.direction {
  | ASC => "ASC"
  | DESC => "DESC"
  }

  `${refString} ${directionString}`
}
