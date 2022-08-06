type joinType = Inner | Left

type t<'p, 's> = {
  table: Table.t<'p, 's>,
  joinType: joinType,
  condition: Expr.t,
}
