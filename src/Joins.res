type t = array<Join.t>

let getTableAliases = joins =>
  Js.Array2.map(joins, join => Belt.Option.mapWithDefault(join, "", Join.getTableAlias))

let toSQL = (joins, queryToString) => {
  joins
  ->Js.Array2.map(Join.toSQL(_, queryToString))
  ->Js.Array2.joinWith(" ")
}
