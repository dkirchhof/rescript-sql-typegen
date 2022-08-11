type t = option<Expr.t>

let toSQL = (havings, tableAliases, queryToString) =>
  switch havings {
  | Some(expr) => `HAVING ${Expr.toSQL(expr, tableAliases, queryToString)}`
  | None => ""
  }
