type t = array<string>

let toSQL = (joins, withAlias) =>
  /* let result = `JOIN ${join.table.name} AS ${join.table.alias}` */

  /* switch join.on { */
  /* | Some(on) => result ++ ` ON ${on->fst->Column.toSQL} = ${on->snd->Column.toSQL}` */
  /* | None => result */
  /* } */

  joins->Js.Array2.mapi((join, i) =>
    if withAlias {
      `JOIN ${join} AS ${Utils.createAlias(i + 1)}`
    } else {
      `JOIN ${join}`
    }
  )->Js.Array2.joinWith(" ")
