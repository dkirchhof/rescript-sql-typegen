module Table = {
  type t<'columns> = {
    name: string,
    columns: 'columns,
  }
}

module Column = {
  type t<'t> = {
    table: string,
    name: string,
    dt: string,
    size: option<int>,
    nullable: bool,
    unique: bool,
    default: option<'t>,
  }

  let dtToSQL = (dt, size) => {
    switch size {
    | Some(s) => `${dt}(${s->Js.Int.toString})`
    | None => dt
    }
  }

  let defaultValueToSQL = defaultValue => {
    let str = Js.String.make(defaultValue)

    "DEFAULT " ++ (Js.Types.test(defaultValue, Js.Types.String) ? `'${str}'` : str)
  }

  let toSQL = column =>
    [
      column.name,
      dtToSQL(column.dt, column.size),
      column.nullable ? "": "NOT NULL",
      column.unique ? "UNIQUE" : "",
      Belt.Option.mapWithDefault(column.default, "", defaultValueToSQL),
    ]
    ->Js.Array2.filter(s => String.length(s) > 0)
    ->Js.Array2.joinWith(" ")
}

module Columns = {
  let toSQL = columns =>
    columns->Obj.magic->Js.Dict.values->Js.Array2.map(column => `  ${column->Column.toSQL}`)
}

module PrimaryKey = {
  type t = {name: string, columns: array<string>}

  let make1 = (name, column: Column.t<_>) => {
    name,
    columns: [column.name],
  }

  let make2 = (name, column1: Column.t<_>, column2: Column.t<_>) => {
    name,
    columns: [column1.name, column2.name],
  }

  let make3 = (name, column1: Column.t<_>, column2: Column.t<_>, column3: Column.t<_>) => {
    name,
    columns: [column1.name, column2.name, column3.name],
  }

  let toSQL = primaryKey =>
    switch primaryKey {
    | Some(pk) => [`  CONSTRAINT ${pk.name} PRIMARY KEY (${pk.columns->Js.Array2.joinWith(", ")})`]
    | None => [``]
    }
}

module ForeignKey = {
  type foreignColumn = {
    table: string,
    name: string,
  }

  type t = {name: string, ownColumn: string, foreignColumn: foreignColumn}

  let make = (name, ownColumn: Column.t<'a>, foreignColumn: Column.t<'a>) => {
    {
      name,
      ownColumn: ownColumn.name,
      foreignColumn: {table: foreignColumn.table, name: foreignColumn.name},
    }
  }

  let toSQL = foreignKey =>
    `  CONSTRAINT ${foreignKey.name} FOREIGN KEY (${foreignKey.ownColumn}) REFERENCES ${foreignKey.foreignColumn.table}(${foreignKey.foreignColumn.name})`
}

module ForeignKeys = {
  let toSQL = foreignKeys => foreignKeys->Js.Array2.map(ForeignKey.toSQL)
}

module Query = {
  type t<'t> = {
    table: Table.t<'t>,
    primaryKey: option<PrimaryKey.t>,
    foreignKeys: array<ForeignKey.t>,
  }
}

let createTable = (table: Table.t<'columns>) => {
  let query: Query.t<'columns> = {
    table,
    primaryKey: None,
    foreignKeys: [],
  }

  query
}

let primaryKey = (query: Query.t<'columns>, getPrimaryKey: 'columns => PrimaryKey.t) => {
  let primaryKey = getPrimaryKey(query.table.columns)->Some

  {...query, primaryKey}
}

let foreignKeys = (query: Query.t<'columns>, getForeignKeys: 'columns => array<ForeignKey.t>) => {
  let foreignKeys = getForeignKeys(query.table.columns)

  {...query, foreignKeys}
}

let toSQL = (query: Query.t<_>) => {
  let innerRows =
    [
      Columns.toSQL(query.table.columns),
      PrimaryKey.toSQL(query.primaryKey),
      ForeignKeys.toSQL(query.foreignKeys),
    ]
    ->Utils.flatten
    ->Js.Array2.filter(s => String.length(s) > 0)
    ->Js.Array2.joinWith(",\n")

  [`CREATE TABLE ${query.table.name} (`, innerRows, `)`]->Js.Array2.joinWith("\n")
}
