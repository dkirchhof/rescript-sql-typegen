type t = option<Expr.t>

let toSQL = selections =>
  switch selections {
  | Some(expr) => `WHERE ${Expr.toSQL(expr)}`
  | None => ""
  }
