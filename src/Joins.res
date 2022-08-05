type joinType = Inner | Left

type join = {
  joinType: joinType,
  tableName: string,
  condition: Expr.t,
}

type t = array<join>

let toSQL = (joins, withAlias) =>
  joins
  ->Js.Array2.mapi((join, i) => {
    let joinTypeString = switch join.joinType {
    | Inner => "INNER"
    | Left => "LEFT"
    }
    
    let selectionString = `ON ${Expr.toSQL(join.condition, true)}`

    if withAlias {
      `${joinTypeString} JOIN ${join.tableName} AS ${Utils.createAlias(i + 1)} ${selectionString}`
    } else {
      `${joinTypeString} JOIN ${join.tableName} ${selectionString}`
    }
  })
  ->Js.Array2.joinWith(" ")
