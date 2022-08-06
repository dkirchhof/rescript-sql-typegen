type t<'p1, 's1, 'p2, 's2> = (option<Join.t<'p1, 's1>>, option<Join.t<'p2, 's2>>)

external toArray: t<_, _, _, _> => array<option<Join.t<_, _>>> = "%identity"

let getTableAliases = joins =>
  Js.Array2.map(joins, join => Belt.Option.mapWithDefault(join, "", Join.getTableAlias))

let toSQL = (joins, tableAliases) => {
  joins
  ->toArray
  ->Js.Array2.map(Belt.Option.map(_, Join.toSQL(_, tableAliases)))
  ->Js.Array2.filter(Belt.Option.isSome)
  ->Js.Array2.joinWith(" ")
}
