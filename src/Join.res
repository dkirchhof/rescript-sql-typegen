type joinType = Inner | Left

type t<'p, 's> = {
  table: Table.t<'p, 's>,
  joinType: joinType,
  condition: Expr.t,
}

let getTableAlias = join => join.table.alias

let toSQL = (join, tableAliases, queryToString) => {
  let joinTypeString = switch join.joinType {
  | Inner => "INNER"
  | Left => "LEFT"
  }

  let selectionString = `ON ${Expr.toSQL(join.condition, tableAliases, queryToString)}`

  `${joinTypeString} JOIN ${join.table.name} AS ${join.table.alias} ${selectionString}`
}
