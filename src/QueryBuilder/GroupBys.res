type t = array<GroupBy.t>

let toSQL = (groupBys, queryToString) => {
  switch groupBys {
  | [] => ""
  | _ => {
      let list = groupBys->Js.Array2.map(GroupBy.toSQL(_, queryToString))->Js.Array2.joinWith(", ")

      `GROUP BY ${list}`
    }
  }
}
