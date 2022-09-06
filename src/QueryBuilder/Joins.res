type t = array<Join.t>

let toSQL = (joins, queryToString) => {
  joins
  ->Js.Array2.map(Join.toSQL(_, queryToString))
  ->Js.Array2.joinWith(" ")
}
