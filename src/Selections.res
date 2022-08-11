type t = option<Expr.t>

let toSQL = (selections, tableAliases, queryToSQL) =>
  switch selections {
  | Some(expr) => `WHERE ${Expr.toSQL(expr, tableAliases, queryToSQL)}`
  | None => ""
  }
