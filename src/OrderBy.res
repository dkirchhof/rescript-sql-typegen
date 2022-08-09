type direction = ASC | DESC

type t = {
  ref: Ref.t,
  direction: direction,
}

let asc = ref => {
  {ref: Ref.boxRef(ref), direction: ASC}
}

let desc = ref => {
  {ref: Ref.boxRef(ref), direction: DESC}
}

let toSQL = (orderBy, tableAliases) => {
  let refString = Ref.toSQL(orderBy.ref, tableAliases)

  let directionString = switch orderBy.direction {
  | ASC => "ASC"
  | DESC => "DESC"
  }

  `${refString} ${directionString}`
}
