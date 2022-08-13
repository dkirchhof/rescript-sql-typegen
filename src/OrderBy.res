type direction = ASC | DESC

type t = {
  ref: Ref.Untyped.t,
  direction: direction,
}

let asc = ref => {
  {ref: Ref.Typed.toUntyped(ref), direction: ASC}
}

let desc = ref => {
  {ref: Ref.Typed.toUntyped(ref), direction: DESC}
}

let toSQL = (orderBy, tableAliases, queryToString) => {
  let refString = Ref.Untyped.toSQL(orderBy.ref, tableAliases, queryToString)

  let directionString = switch orderBy.direction {
  | ASC => "ASC"
  | DESC => "DESC"
  }

  `${refString} ${directionString}`
}
