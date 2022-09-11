type any

type columnOptions = {
  tableAlias: string,
  columnName: string,
  aggType: option<Aggregation.t>,
}

type t<'a> =
  | ColumnRef(columnOptions)
  | ValueRef('a)
  | QueryRef('a)

type anyRef = t<any>

let makeColumnRef = column => {
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

let columnRefToSQL = (options, withNamespace) => {
  let columnString = withNamespace
    ? `${options.tableAlias}.${options.columnName}`
    : options.columnName

  switch options.aggType {
  | Some(COUNT) => `COUNT(${columnString})`
  | Some(SUM) => `SUM(${columnString})`
  | Some(AVG) => `AVG(${columnString})`
  | Some(MIN) => `MIN(${columnString})`
  | Some(MAX) => `MAX(${columnString})`
  | None => columnString
  }
}

let valueRefToSQL = value => {
  let str = Js.String.make(value)

  if Js.Types.test(value, Js.Types.String) {
    `'${str}'`
  } else {
    str
  }
}

let queryRefToSQL = (options, queryToString) => `(${queryToString(options->Obj.magic)})`

let toProjectionSQL = (projection, withNamespace, alias, queryToString) => {
  switch projection {
  | ColumnRef(options) => {
      let columnRefSQL = columnRefToSQL(options, withNamespace)

      if columnRefSQL === alias {
        columnRefSQL
      } else {
        `${columnRefToSQL(options, withNamespace)} AS "${alias}"`
      }
    }

  | ValueRef(value) => `${valueRefToSQL(value)} AS "${alias}"`
  | QueryRef(query) => `${queryRefToSQL(query, queryToString)} AS "${alias}"`
  }
}

let toSQL = (ref, queryToString) => {
  switch ref {
  | ColumnRef(options) => columnRefToSQL(options, false)
  | ValueRef(value) => valueRefToSQL(value)
  | QueryRef(query) => queryRefToSQL(query, queryToString)
  }
}
