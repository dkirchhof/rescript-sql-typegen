type t = array<GroupBy.t>

let toSQL = (groupBys, tableAliases, queryToString) => {
  switch groupBys {
  | [] => ""
  | _ => {
      let list = groupBys->Js.Array2.map(GroupBy.toSQL(_, tableAliases, queryToString))->Js.Array2.joinWith(", ")

      `GROUP BY ${list}`
    }
  }
}
