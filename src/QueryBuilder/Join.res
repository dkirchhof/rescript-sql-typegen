type joinType = Inner | Left

type t = {
  table: Table.t,
  joinType: joinType,
  condition: option<Expr.t>,
}

let make = (tableName, tableAlias, joinType) => {
  table: Table.make(tableName, tableAlias),
  joinType,
  condition: None,
}

let toSQL = (join, queryToString) => {
  let joinTypeString = switch join.joinType {
  | Inner => "INNER"
  | Left => "LEFT"
  }

  let selectionString = switch join.condition {
  | Some(condition) => ` ON ${Expr.toSQL(condition, queryToString)}`
  | None => ""
  }

  `${joinTypeString} JOIN ${join.table.name} AS "${join.table.alias}"${selectionString}`
}
