type t = option<Expr.t>

let toSQL = (selections, withAlias) =>
  switch selections {
  | Some(expr) => [`WHERE ${Expr.toSQL(expr, withAlias)}`]
  | None => [""]
  }
