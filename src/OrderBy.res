type direction = ASC | DESC

type t = {
  ref: Ref.t,
  direction: direction,
}

let asc = ref => {
  {ref: Ref.tFromT2(ref), direction: ASC}
}

let desc = ref => {
  {ref: Ref.tFromT2(ref), direction: DESC}
}

let toSQL = (orderBy, tableAliases, queryToString) => {
  let refString = Ref.toSQL(orderBy.ref, tableAliases, queryToString)

  let directionString = switch orderBy.direction {
  | ASC => "ASC"
  | DESC => "DESC"
  }

  `${refString} ${directionString}`
}
