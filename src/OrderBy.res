type direction = ASC | DESC

type t = {
  column: ColumnRef.t,
  direction: direction,
}

let toSQL = (orderBy, tableAliases) => {
  let columnString = ColumnRef.toSQL(orderBy.column, tableAliases)

  let directionString = switch orderBy.direction {
  | ASC => "ASC"
  | DESC => "DESC"
  }

  `${columnString} ${directionString}`
}
