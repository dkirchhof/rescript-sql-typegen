type direction = ASC | DESC

type t = {
  ref: Ref.Untyped.t,
  direction: direction,
}

let asc = ref => {
  {ref: ref->Ref.Typed.toUntyped, direction: ASC}
}

let desc = ref => {
  {ref: ref->Ref.Typed.toUntyped, direction: DESC}
}

let toSQL = (orderBy, queryToString) => {
  let refString = Ref.Untyped.toSQL(orderBy.ref, queryToString)

  let directionString = switch orderBy.direction {
  | ASC => "ASC"
  | DESC => "DESC"
  }

  `${refString} ${directionString}`
}
