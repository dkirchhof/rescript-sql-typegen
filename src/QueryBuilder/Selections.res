type t = option<Expr.t>

let toSQL = (selections, queryToSQL) =>
  switch selections {
  | Some(expr) => `WHERE ${Expr.toSQL(expr, queryToSQL)}`
  | None => ""
  }
