type t = Js.Dict.t<Js.Dict.t<Projection.t>>

let toSQL = (projections, queryToString) =>{
  Js.log(projections)

  /* switch projections { */
  /* | Some(projections') => */
  /*  `SELECT ${projections'->Belt.Array.joinWith(", ", Projection.toSQL(_, queryToString))}` */
  /* | None => `SELECT *` */
  /* } */

  projections->Js.Dict.entries->Js.Array2.map(((tableAlias, columns)) => columns)->Js.Array2.joinWith(", ")

}
