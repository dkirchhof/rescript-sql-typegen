type joinType = Inner | Left

type join = {
  joinType: joinType,
  tableName: string,
  leftColumn: ColumnRef.t,
  rightColumn: ColumnRef.t,
}

type t = array<join>

let toSQL = (joins, withAlias) =>
  joins
  ->Js.Array2.mapi((join, i) => {
    let joinTypeString = switch join.joinType {
    | Inner => "INNER"
    | Left => "LEFT"
    }
    
    let left = ColumnRef.toSQL(join.leftColumn, true);
    let right = ColumnRef.toSQL(join.rightColumn, true);

    let selectionString = `ON ${left} = ${right}`

    if withAlias {
      `${joinTypeString} JOIN ${join.tableName} AS ${Utils.createAlias(i + 1)} ${selectionString}`
    } else {
      `${joinTypeString} JOIN ${join.tableName} ${selectionString}`
    }
  })
  ->Js.Array2.joinWith(" ")
