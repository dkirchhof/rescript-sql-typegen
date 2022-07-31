type t = array<string>

let toSQL = joins =>
  /* let result = `JOIN ${join.table.name} AS ${join.table.alias}` */

  /* switch join.on { */
  /* | Some(on) => result ++ ` ON ${on->fst->Column.toSQL} = ${on->snd->Column.toSQL}` */
  /* | None => result */
  /* } */

  joins
  ->Js.Array2.mapi((join, i) => `JOIN ${join} AS ${Belt.Int.toString(i + 1)}`)
  ->Js.Array2.joinWith("\n")
