type t = option<Expr.t>

let toSQL = (havings, withAlias) =>
  switch havings {
  | Some(expr) => `HAVING ${Expr.toSQL(expr, withAlias)}`
  | None => ""
  }
