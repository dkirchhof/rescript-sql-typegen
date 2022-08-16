type t = option<Expr.t>

let toSQL = (havings, queryToString) =>
  switch havings {
  | Some(expr) => `HAVING ${Expr.toSQL(expr, queryToString)}`
  | None => ""
  }
