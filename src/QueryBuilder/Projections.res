type t = Js.Dict.t<Js.Dict.t<Projection.t>>

let toSQL = (projections, queryToString) => {
  `SELECT ${projections
    ->Obj.magic
    ->Js.Dict.entries
    ->Js.Array2.map(((namespace, columns)) => {
      columns
      ->Js.Dict.entries
      ->Js.Array2.map(((name, ref)) =>
        Projection.toSQL(ref, `${namespace}.${name}`, queryToString)
      )
      ->Js.Array2.joinWith(", ")
    })
    ->Js.Array2.joinWith(", ")}`
}
