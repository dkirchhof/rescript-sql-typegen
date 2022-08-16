type t = array<OrderBy.t>

let toSQL = (orderBys, queryToString) => {
  switch orderBys {
  | [] => ""
  | _ => {
      let list = orderBys->Js.Array2.map(OrderBy.toSQL(_, queryToString))->Js.Array2.joinWith(", ")

      `ORDER BY ${list}`
    }
  }
}
