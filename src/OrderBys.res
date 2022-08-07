type t = array<OrderBy.t>

let toSQL = (orderBys, tableAliases) => {
  switch orderBys {
  | [] => ""
  | _ => {
      let list = orderBys->Js.Array2.map(OrderBy.toSQL(_, tableAliases))->Js.Array2.joinWith(", ")

      `ORDER BY ${list}`
    }
  }
}
