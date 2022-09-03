type columnOptions = {
  tableAlias: string,
  columnName: string,
  aggType: option<Aggregation.t>,
}

module Untyped = {
  type t =
    | ColumnRef(columnOptions)
    | ValueRef(ValueRef.t)
    | QueryRef(QueryRef.t)

  let columnRefToSQL = options => {
    let columnString = `${options.tableAlias}.${options.columnName}`

    switch options.aggType {
    | Some(COUNT) => `COUNT(${columnString})`
    | Some(SUM) => `SUM(${columnString})`
    | Some(AVG) => `AVG(${columnString})`
    | Some(MIN) => `MIN(${columnString})`
    | Some(MAX) => `MAX(${columnString})`
    | None => columnString
    }
  }

  let toSQL = (ref, queryToString) => {
    switch ref {
    | ColumnRef(options) => columnRefToSQL(options)
    | ValueRef(ref) => ValueRef.toSQL(ref)
    | QueryRef(ref) => QueryRef.toSQL(ref, queryToString)
    }
  }

  let toProjectionSQL = (projection, alias, queryToString) => {
    switch projection {
    | ColumnRef(ref) => `${columnRefToSQL(ref)} AS "${alias}"`
    | ValueRef(ref) => `${ValueRef.toSQL(ref)} AS "${alias}"`
    | QueryRef(ref) => `${QueryRef.toSQL(ref, queryToString)} AS "${alias}"`
    }
  }
}

module Typed = {
  type t<'a> =
    | ColumnRef(columnOptions)
    | ValueRef(ValueRef.t)
    | QueryRef(QueryRef.t)

  let makeColumnRef = column => {
    open DDL.Column

    {
      tableAlias: column.table,
      columnName: column.name,
      aggType: None,
    }->ColumnRef
  }

  let updateAggType = (t, aggType) =>
    switch t {
    | ColumnRef(ref) => ColumnRef({...ref, aggType})
    | ValueRef(_) => t
    | QueryRef(_) => t
    }

  external unbox: t<'a> => 'a = "%identity"
  external toUntyped: t<'a> => Untyped.t = "%identity"
}
