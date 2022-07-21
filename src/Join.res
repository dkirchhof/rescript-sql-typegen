type joinType = InnerJoin | LeftJoin

type t = {
  table: Table.t,
  joinType: joinType,
  on: option<(Column.u, Column.u)>,
}

let toSQL = join => {
  let result = `JOIN ${join.table.name} AS ${join.table.alias}`

  switch join.on {
  | Some(on) => result ++ ` ON ${on->fst->Column.toSQL} = ${on->snd->Column.toSQL}`
  | None => result
  }
}
