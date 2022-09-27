type any

type aggregationType = COUNT | SUM | AVG | MIN | MAX

type columnOptions = {
  tableAlias: string,
  columnName: string,
  aggType: option<aggregationType>,
}

type t<'a> =
  | ColumnRef(columnOptions)
  | ValueRef('a)
  | QueryRef('a)

type anyRef = t<any>

let makeColumnRef = (column: DDL.Column.t<'a>): t<'a> => {
  open DDL.Column

  {
    tableAlias: column.table,
    columnName: column.name,
    aggType: None,
  }->ColumnRef
}

let makeValueRef = value => ValueRef(value)

let makeQueryRef = query => QueryRef(query->Obj.magic)

let updateAggType = (t, aggType) =>
  switch t {
  | ColumnRef(ref) => ColumnRef({...ref, aggType})
  | ValueRef(_) => t
  | QueryRef(_) => t
  }

external unbox: t<'a> => 'a = "%identity"
external toAnyRef: t<'a> => t<any> = "%identity"

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

let valueRefToSQL = Sanitizer.valueToSQL

let queryRefToSQL = (options, queryToString) => `(${queryToString(options->Obj.magic)})`

let toProjectionSQL = (projection, alias, queryToString) => {
  switch projection {
  | ColumnRef(options) => `${columnRefToSQL(options)} AS ${alias}`
  | ValueRef(value) => `${valueRefToSQL(value)} AS ${alias}`
  | QueryRef(query) => `${queryRefToSQL(query, queryToString)} AS ${alias}`
  }
}

let toSQL = (ref, queryToString) => {
  switch ref {
  | ColumnRef(options) => columnRefToSQL(options)
  | ValueRef(value) => valueRefToSQL(value)
  | QueryRef(query) => queryRefToSQL(query, queryToString)
  }
}
